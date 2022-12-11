import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone_riverpod/core/failer.dart';
import 'package:reddit_clone_riverpod/core/providers/firebase_providers.dart';
import 'package:reddit_clone_riverpod/core/type_def.dart';

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  return StorageRepository(firebaseStorage: ref.read(firebaseStorageProvider));
});

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      final snapshot = await ref.putFile(file!);
      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failer(e.toString()));
    }
  }
}
