import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/features/community/controller/community_controller.dart';
import 'package:reddit_clone_riverpod/models/community_model.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';
import 'package:reddit_clone_riverpod/route.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({
    Key? key,
    required this.communityName,
  }) : super(key: key);

  final String communityName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(title: Text('r/$communityName')),
      body: ref.watch(getCommunitybyNameProvider(communityName)).when(
            data: (community) {
              return _Community(community: community, user: user);
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

class _Community extends StatelessWidget {
  const _Community({
    Key? key,
    required this.community,
    required this.user,
  }) : super(key: key);

  final Community community;
  final UserModel user;

  void navigateToModTools(BuildContext context) {
    Routemaster.of(context).push('${RouteNames.modTools}/${community.name}');
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: ((context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    community.banner,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Align(
                    alignment: Alignment.topLeft,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(community.avatar),
                      radius: 35,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'r/${community.name}',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      community.mods.contains(user.uid)
                          ? OutlinedButton(
                              onPressed: () => navigateToModTools(context),
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: const Text('Mod Tools'),
                            )
                          : OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: community.members.contains(user.uid) ? const Text('JOINED') : const Text('JOIN'),
                            )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('${community.members.length} members'),
                  )
                ],
              ),
            ),
          )
        ];
      }),
      body: const Text('body'),
    );
  }
}
