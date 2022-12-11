import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({
    required this.name,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text("Edit Community"),
        centerTitle: false,
        actions: [
          TextButton(
            child: const Text('save'),
            onPressed: () => () {},
          )
        ],
      ),
      body: Column(
        children: const [],
      ),
    );
  }
}
