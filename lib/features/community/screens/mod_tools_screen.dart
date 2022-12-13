import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/route.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends ConsumerWidget {
  final String name;
  const ModToolsScreen({required this.name, Key? key}) : super(key: key);

  void goToEditCommunity(BuildContext context) {
    Routemaster.of(context).push('${RouteNames.editComunity}/$name');
  }

  void goToAddMod(BuildContext context) {
    Routemaster.of(context).push('${RouteNames.addModsScreen}/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('ModToolsScreen')),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add moderators'),
            leading: const Icon(Icons.add_moderator),
            onTap: () => goToAddMod(context),
          ),
          ListTile(
            title: const Text('Edit Community'),
            leading: const Icon(Icons.edit),
            onTap: () => goToEditCommunity(context),
          ),
        ],
      ),
    );
  }
}
