import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  final WidgetRef ref;

  SearchCommunityDelegate(this.ref);

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
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(searchCommunityProvider(query)).when(
          data: (communities) => ListView.builder(
            itemCount: communities.length,
            itemBuilder: (context, index) {
              final community = communities[index];
              return ListTile(
                title: Text('r/${community.name}'),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(community.avatar),
                ),
                onTap: () => navigateToCommunityScreen(community.name, context),
              );
            },
          ),
          error: (error, stack) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
