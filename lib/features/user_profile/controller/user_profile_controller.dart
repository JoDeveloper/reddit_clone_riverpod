import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone_riverpod/core/providers/storage_repository_provider.dart';
import 'package:reddit_clone_riverpod/core/utils.dart';
import 'package:reddit_clone_riverpod/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone_riverpod/models/user_model.dart';

/// Creating a provider for the UserProfileController class.
final communityControllerProvider =
    StateNotifierProvider<UserProfileController, bool>((ref) {
  return UserProfileController(
    userProfileRepository: ref.watch(userProfileRepositoryProvider),
    storageRepository: ref.watch(storageRepositoryProvider),
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _repository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref,
  })  : _repository = userProfileRepository,
        _storageRepository = storageRepository,
        _ref = ref,
        super(false);

  void editUserProfile({
    required UserModel user,
    required File? bannerImage,
    required File? profileImage,
    required BuildContext context,
  }) async {
    state = true;
    if (profileImage != null) {
      final profile = await _storageRepository.storeFile(
        path: 'users/profile',
        id: user.name,
        file: profileImage,
      );
      state = false;
      profile.fold(
        (error) => showSnackBar(context, error.message),
        (image) => user.copyWith(profilePic: image),
      );
    }
  }
}
