import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone_riverpod/features/community/controller/community_controller.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({required this.name, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {
  Set<String> uids = {};
  int rebuild = 0;

  void addUid(String uid) => setState(() {
        uids.add(uid);
      });

  void removeUid(String uid) => setState(() {
        uids.remove(uid);
      });

  void saveMods() {
    ref
        .read(communityControllerProvider.notifier)
        .addModsCommunity(widget.name, uids.toList(), context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveMods,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
            data: (community) => ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index) {
                final id = community.members[index];
                return ref.watch(getUserDataProvider(id)).when(
                      data: (user) {
                        if (community.members.contains(id) && rebuild == 0) {
                          uids.add(id);
                        }
                        // to check that the id is checked first time only
                        rebuild++;
                        return CheckboxListTile(
                          title: Text(user!.name),
                          value: uids.contains(id),
                          onChanged: (value) {
                            if (value!) {
                              addUid(id);
                            } else {
                              removeUid(id);
                            }
                          },
                        );
                      },
                      error: (error, stack) =>
                          ErrorText(error: error.toString()),
                      loading: () => const Loader(),
                    );
              },
            ),
            error: (error, stack) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
    );
  }
}
