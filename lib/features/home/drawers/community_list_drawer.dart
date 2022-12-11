import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/features/community/controller/community_controller.dart';
import 'package:reddit_clone_riverpod/route.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  /// It navigates to the route named "createCommunity"
  ///
  /// Args:
  ///   context (BuildContext): The context of the widget that is calling the function.
  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push(RouteNames.createCommunity);
  }

  /// It navigates to the community screen, but it also passes in the id of the community that was
  /// clicked
  ///
  /// Args:
  ///   id (String): The id of the community you want to navigate to.
  ///   context (BuildContext): The context of the widget that is calling the function.
  void navigateToCommunityScreen(String name, BuildContext context) {
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            title: const Text('Create a community'),
            leading: const Icon(Icons.add),
            onTap: () => navigateToCreateCommunity(context),
          ),
          ref.watch(getUserCommunityProvider).when(
                data: (communities) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: communities.length,
                      itemBuilder: ((context, index) {
                        final comunity = communities[index];
                        return ListTile(
                          title: Text('r/${comunity.name}'),
                          leading: CircleAvatar(backgroundImage: NetworkImage(comunity.avatar)),
                          onTap: () => navigateToCommunityScreen(comunity.name, context),
                        );
                      }),
                    ),
                  );
                },
                loading: () => const Loader(),
                error: (err, sta) => ErrorText(error: err.toString()),
              ),
        ],
      ),
    );
  }
}
