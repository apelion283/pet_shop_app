import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
  });

  factory UserModel.fromFirebaseUser(User? user) {
    return UserModel(
      id: user?.uid ?? '',
      email: user?.email ?? '',
      name: user?.displayName ?? '',
    );
  }
}
