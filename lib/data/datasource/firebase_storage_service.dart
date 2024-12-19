import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';

abstract class FirebaseStorageService {
  FirebaseStorage get storage;
  Future<Either<Failure, String>> uploadAndDeleteCurrentAvatar(
      {required Uint8List avatarPath,
      String? currentAvatarUrl,
      required String userId});
}

class FirebaseStorageServiceImpl extends FirebaseStorageService {
  @override
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<Either<Failure, String>> uploadAndDeleteCurrentAvatar(
      {required Uint8List avatarPath,
      String? currentAvatarUrl,
      required String userId}) async {
    try {
      final avatarRef = storage.ref().child("avatars/$userId");
      UploadTask uploadTask = avatarRef.putData(avatarPath);
      if (currentAvatarUrl != null) {
        await storage.refFromURL(currentAvatarUrl).delete();
      }
      TaskSnapshot taskSnapshot = await uploadTask;
      return Right(await taskSnapshot.ref.getDownloadURL());
    } on FirebaseException catch (e) {
      print(e.message);
      return Left(Failure(code: e.code, message: e.message));
    }
  }
}
