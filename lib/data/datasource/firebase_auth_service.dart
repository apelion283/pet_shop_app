import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/models/user_model.dart';

abstract class FirebaseAuthService {
  FirebaseAuth? get auth;

  Future<Either<Failure, UserModel>> signUp(
      {required String email, required String password, required String name});

  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<Either<Failure, UserModel>> getCurrentUserInformation();
  Future<Either<Failure, void>> updatePassword(
      {required String currentPassword, required String newPassword});
  Future<Failure?> reauthenticateCredential(
      {required String email, required String password});

  Future<bool> sendResetPasswordEmail(String email);
  Future<Either<Failure, void>> updateUserInformation(
      {required UserModel user});

  Future<void> signOut();
}

class FirebaseAuthServiceImpl implements FirebaseAuthService {
  @override
  FirebaseAuth? auth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, UserModel>> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final result = await auth?.createUserWithEmailAndPassword(
          email: email, password: password);
      await result?.user?.updateDisplayName(name);
      return Right(UserModel.fromFirebaseUser(result?.user));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<Either<Failure, UserModel>> getCurrentUserInformation() async {
    try {
      final user = auth?.currentUser;
      return Right(UserModel.fromFirebaseUser(user));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await auth?.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(UserModel.fromFirebaseUser(result?.user));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(message: e.message, code: e.code));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth?.signOut();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<bool> sendResetPasswordEmail(String email) async {
    try {
      await auth?.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Either<Failure, void>> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    try {
      final result = await reauthenticateCredential(
          email: auth?.currentUser?.email ?? "", password: currentPassword);
      if (result != null) {
        return Left(result);
      } else {
        return Right(await auth?.currentUser?.updatePassword(newPassword));
      }
    } on FirebaseAuthException catch (e) {
      return Left(Failure(code: e.code, message: e.message));
    }
  }

  @override
  Future<Failure?> reauthenticateCredential(
      {required String email, required String password}) async {
    try {
      await auth?.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      return null;
    } on FirebaseAuthException catch (e) {
      return Failure(code: e.code, message: e.message);
    }
  }

  @override
  Future<Either<Failure, void>> updateUserInformation(
      {required UserModel user}) async {
    try {
      return Right(await auth?.currentUser
          ?.updateProfile(displayName: user.name, photoURL: user.avatarUrl));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(code: e.code, message: e.message));
    }
  }
}
