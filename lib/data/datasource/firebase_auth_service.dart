import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/models/user_model.dart';

abstract interface class FirebaseAuthService {
  FirebaseAuth? get auth;

  Future<Either<Failure, UserModel>> signUp(
      {required String email, required String password, required String name});

  Future<UserModel> signInWithEmailAndPassword(
      {required String email, required String password});

  Future<UserModel> getCurrentUserInformation();

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
  Future<UserModel> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    final result = await auth?.signInWithEmailAndPassword(
        email: email, password: password);
    return UserModel.fromFirebaseUser(result!.user);
  }

  @override
  Future<void> signOut() async {
    try {
      await auth?.signOut();
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}
