// loggedOut Routes
import 'package:flutter/material.dart';
import 'package:reddit_clone_riverpod/features/auth/screen/login_screen.dart';
import 'package:reddit_clone_riverpod/features/community/screens/create_community_screen.dart';
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
  },
);

abstract class RouteNames {
  static String home = '/';
  static String createCommunity = '/';
}
