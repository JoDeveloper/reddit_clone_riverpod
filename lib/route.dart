// loggedOut Routes
import 'package:flutter/material.dart';
import 'package:reddit_clone_riverpod/features/auth/screen/login_screen.dart';
import 'package:reddit_clone_riverpod/features/community/screens/add_mods_scree.dart';
import 'package:reddit_clone_riverpod/features/community/screens/community_screen.dart';
import 'package:reddit_clone_riverpod/features/community/screens/create_community_screen.dart';
import 'package:reddit_clone_riverpod/features/community/screens/edit_community_screen.dart';
import 'package:reddit_clone_riverpod/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_clone_riverpod/features/home/screen/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {
    RouteNames.home: (_) => const MaterialPage(child: LoginScreen()),
  },
);

// loggedIn Routes
final loggedInRoute = RouteMap(
  routes: {
    RouteNames.home: (_) => const MaterialPage(child: HomeScreen()),
    RouteNames.createCommunity: (_) => const MaterialPage(child: CreateCommunityScreen()),
    RouteNames.communityScreen: (route) => MaterialPage(child: CommunityScreen(communityName: route.pathParameters['name']!)),
    RouteNames.modTools: (route) => MaterialPage(child: ModToolsScreen(name: route.pathParameters['name']!)),
    RouteNames.editComunity: (route) => MaterialPage(child: EditCommunityScreen(name: route.pathParameters['name']!)),
    RouteNames.addModsScreen: (route) => MaterialPage(child: AddModsScreen(name: route.pathParameters['name']!)),
  },
);

abstract class RouteNames {
  static String home = '/';
  static String communityScreen = '/r/:name';
  static String createCommunity = '/create-community';
  static String modTools = '/mod-tools:name';
  static String editComunity = '/edit-community:name';
  static String addModsScreen = '/add-mods-community:name';
}
