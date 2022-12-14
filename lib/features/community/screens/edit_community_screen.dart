import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/common/error_text.dart';
import 'package:reddit_clone_riverpod/core/common/loader.dart';
import 'package:reddit_clone_riverpod/core/constants/constants.dart';
import 'package:reddit_clone_riverpod/core/utils.dart';
import 'package:reddit_clone_riverpod/features/community/controller/community_controller.dart';
import 'package:reddit_clone_riverpod/models/community_model.dart';
import 'package:reddit_clone_riverpod/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;

  const EditCommunityScreen({
    required this.name,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerImage;
  File? profileImage;

  void selectBannerImage() async {
    final res = await pickImage();
    if (res == null) return;

    setState(() {
      bannerImage = File(res.files.first.path!);
    });
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res == null) return;
    setState(() {
      profileImage = File(res.files.first.path!);
    });
  }

  void save(Community community) {
    ref.read(communityControllerProvider.notifier).editCommunity(
          community: community,
          bannerImage: bannerImage,
          profileImage: profileImage,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.read(communityControllerProvider);
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community) => Scaffold(
            backgroundColor: Pallete.darkModeAppTheme.backgroundColor,
            appBar: AppBar(
              title: const Text("Edit Community"),
              centerTitle: false,
              actions: [
                TextButton(
                  child: const Text('save'),
                  onPressed: () => save(community),
                )
              ],
            ),
            body: isLoading
                ? const Loader()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: selectBannerImage,
                                child: DottedBorder(
                                  borderType: BorderType.RRect,
                                  radius: const Radius.circular(10),
                                  dashPattern: const [10, 4],
                                  strokeCap: StrokeCap.round,
                                  color: Pallete.darkModeAppTheme.textTheme
                                      .bodyText2!.color!,
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: bannerImage != null
                                        ? Image.file(bannerImage!)
                                        : (community.banner.isEmpty ||
                                                community.banner ==
                                                    Constants.bannerDefault)
                                            ? const Icon(
                                                Icons.camera_alt_outlined,
                                                size: 10,
                                              )
                                            : Image.network(community.banner),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: GestureDetector(
                                  onTap: selectProfileImage,
                                  child: profileImage != null
                                      ? CircleAvatar(
                                          backgroundImage:
                                              FileImage(profileImage!),
                                          radius: 32,
                                        )
                                      : CircleAvatar(
                                          backgroundImage:
                                              NetworkImage(community.avatar),
                                          radius: 32,
                                        ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          ),
          error: (error, stack) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
