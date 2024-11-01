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

  Future<UserModel> getCurrentUserInformation();

  Future<bool> sendResetPasswordEmail(String email);

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
      return Right(UserModel.fromFirebaseUser(result!.user));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message, e.code));
    }
  }

  @override
  Future<UserModel> getCurrentUserInformation() async {
    final user = auth?.currentUser;
    return UserModel.fromFirebaseUser(user);
  }

  @override
  Future<Either<Failure, UserModel>> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await auth?.signInWithEmailAndPassword(
          email: email, password: password);
      return Right(UserModel.fromFirebaseUser(result?.user));
    } on FirebaseAuthException catch (e) {
      return Left(Failure(e.message, e.code));
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
}
