import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/repository/auth_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';

class AuthUsecase {
  AuthRepositoryImpl authRepositoryImpl;
  AuthUsecase(this.authRepositoryImpl);

  Future<Either<Failure, UserEntity>> getCurrentUserInformation() async {
    return await authRepositoryImpl.getCurrentUserInformation();
  }

  Future<Either<Failure, void>> updateUserInformation(
      {required UserEntity user, required Uint8List? newAvatar}) async {
    return await authRepositoryImpl.updateUserInformation(
        user: user, newAvatar: newAvatar);
  }

  Future<Either<Failure, UserEntity>> signUp(
      {required String email,
      required String password,
      required String name}) async {
    return await authRepositoryImpl.signUp(
        email: email, password: password, name: name);
  }

  Future<void> signOut() async {
    await authRepositoryImpl.signOut();
  }

  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    return await authRepositoryImpl.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<Either<Failure, void>> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    final result = await authRepositoryImpl.updatePassword(
        currentPassword: currentPassword, newPassword: newPassword);
    return result.fold((l) => Left(result.left), (r) => Right(result.right));
  }

  Future<bool> sendResetPasswordEmail(String email) async {
    return await authRepositoryImpl.sendResetPasswordEmail(email);
  }
}
