import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({Key? key, required this.uid}) : super(key: key);
  final String uid;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(title: Text(user.name)),
      body: ref.watch(getUserDataProvider(uid)).when(
            data: (user) => _UserInfoSection(user: user!),
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}

class _UserInfoSection extends ConsumerWidget {
  const _UserInfoSection({
    Key? key,
    required this.user,
  }) : super(key: key);

  final UserModel user;

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('/edit-profile/${user.uid}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            expandedHeight: 250,
            floating: true,
            snap: true,
            flexibleSpace: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    user.banner,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(user.profilePic),
                    radius: 45,
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(20),
                  child: OutlinedButton(
                    onPressed: () => navigateToEditUser(context),
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                    ),
                    child: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'u/${user.name}',
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      '${user.karma} karma',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Divider(thickness: 2),
                ],
              ),
            ),
          ),
        ];
      },
      body: const Text('user posts'),
    );
  }
}
