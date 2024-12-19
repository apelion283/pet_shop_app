import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_auth_service.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_storage_service.dart';
import 'package:flutter_pet_shop_app/data/models/user_model.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> getCurrentUserInformation();
  Future<bool> sendResetPasswordEmail(String email);
  Future<Either<Failure, UserEntity>> signUp(
      {required String email, required String password, required String name});
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<Either<Failure, void>> updatePassword(
      {required String currentPassword, required String newPassword});
  Future<Either<Failure, void>> updateUserInformation(
      {required UserEntity user});
  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;
  final FirebaseStorageService firebaseStorageService;
  AuthRepositoryImpl(this.firebaseAuthService, this.firebaseStorageService);

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserInformation() async {
    try {
      final result = await firebaseAuthService.getCurrentUserInformation();
      return result.fold((l) => Left(l), (r) => Right(r));
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await firebaseAuthService.signInWithEmailAndPassword(
          email: email, password: password);
      return result.fold((l) => Left(l), (r) => Right(r));
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuthService.signOut();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final result = await firebaseAuthService.signUp(
          email: email, password: password, name: name);
      return result.fold((l) => Left(l), (r) => Right(r));
    } on Exception catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<bool> sendResetPasswordEmail(String email) async {
    try {
      final result = await firebaseAuthService.sendResetPasswordEmail(email);
      if (result) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    final result = await firebaseAuthService.updatePassword(
        currentPassword: currentPassword, newPassword: newPassword);
    return result.fold((l) => Left(result.left), (r) => Right(result.right));
  }

  @override
  Future<Either<Failure, void>> updateUserInformation(
      {required UserEntity user, Uint8List? newAvatar}) async {
    if (newAvatar != null) {
      final result = await firebaseStorageService.uploadAndDeleteCurrentAvatar(
          avatarPath: newAvatar,
          currentAvatarUrl: user.avatarUrl,
          userId: user.id);
      if (result.isRight) {
        return await firebaseAuthService.updateUserInformation(
            user: UserModel(
                id: user.id,
                email: user.email,
                name: user.name,
                avatarUrl: result.right));
      } else {
        return Left(result.left);
      }
    } else {
      return await firebaseAuthService.updateUserInformation(
          user: UserModel(id: user.id, email: user.email, name: user.name));
    }
  }
}
