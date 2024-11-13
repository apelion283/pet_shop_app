import 'package:equatable/equatable.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';

class AuthState extends Equatable {
  final UserEntity? user;
  final AuthenticationState? authState;
  final Failure? error;

  const AuthState(
      {this.user,
      this.authState = AuthenticationState.unAuthenticated,
      this.error});

  AuthState copyWith(
      {UserEntity? user, AuthenticationState? state, Failure? error}) {
    return AuthState(
      user: user,
      authState: state ?? authState,
      error: error,
    );
  }

  @override
  List<Object?> get props => [user, authState, error];
}
