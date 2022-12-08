import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/features/community/controller/community_controller.dart';
import 'package:reddit_clone_riverpod/models/community_model.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({
    Key? key,
    required this.communityName,
  }) : super(key: key);

  final String communityName;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('CommunityScreen')),
      body: ref.watch(getCommunitybyNameProvider(communityName)).when(
            data: (community) => _CommunityView(community: community),
            loading: () => const Loader(),
            error: (err, stc) => ErrorText(error: err.toString()),
          ),
    );
  }
}

class _CommunityView extends StatelessWidget {
  final Community community;
  const _CommunityView({
    Key? key,
    required this.community,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 150,
            floating: true,
            snap: true,
            flexibleSpace: Stack(children: [
              Positioned.fill(
                child: Image.network(
                  community.banner,
                  fit: BoxFit.cover,
                ),
              )
            ]),
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
                  const SizedBox(height: 7.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '/r/${community.name}',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20)),
                        child: const Text(
                          'Join',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${community.members.length} members',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ];
      },
      body: const Text('Displaying posts'),
    );
  }
}
