import 'package:either_dart/either.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_auth_service.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> getCurrentUserInformation();
  Future<bool> sendResetPasswordEmail(String email);
  Future<Either<Failure, UserEntity>> signUp(
      {required String email, required String password, required String name});
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<void> signOut();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthService firebaseAuthService;
  AuthRepositoryImpl(this.firebaseAuthService);

  @override
  Future<Either<Failure, UserEntity>> getCurrentUserInformation() async {
    try {
      final result = await firebaseAuthService.getCurrentUserInformation();
      return Right(result);
    } catch (e) {
      return Left(Failure(e.toString()));
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
      return Left(Failure(e.toString()));
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
      return Left(Failure(e.toString()));
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
}
