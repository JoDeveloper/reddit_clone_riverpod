import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/route.dart';
import 'package:reddit_clone_riverpod/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({Key? key}) : super(key: key);

  void signOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  void goToProfilePage(BuildContext context, String uid) {
    Routemaster.of(context).push('${RouteNames.userProfileScreen}/$uid');
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return SafeArea(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user.profilePic),
            radius: 70,
          ),
          const SizedBox(height: 10),
          Text(
            user.name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(),
          ListTile(
            title: const Text('My Profile'),
            leading: const Icon(Icons.person),
            onTap: () => goToProfilePage(context, user.uid),
          ),
          ListTile(
            title: const Text('LogOut'),
            leading: Icon(
              Icons.logout,
              color: Pallete.redColor,
            ),
            onTap: () => ref.watch(authControllerProvider.notifier).signOut(),
          ),
          Switch.adaptive(
            value: ref.watch(themeNotifierProvider.notifier).isDarkMode,
            onChanged: (value) => toggleTheme(ref),
          ),
        ],
      ),
    );
  }
}
