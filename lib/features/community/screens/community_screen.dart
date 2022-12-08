import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      body: const Center(
        child: Text('CommunityScreen'),
      ),
    );
  }
}
