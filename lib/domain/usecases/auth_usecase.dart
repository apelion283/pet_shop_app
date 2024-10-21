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
}
