import 'package:bloc/bloc.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_auth_service.dart';
import 'package:flutter_pet_shop_app/data/repository/auth_repository.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';
import 'package:flutter_pet_shop_app/domain/usecases/auth_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthState());

  final _authUsecase =
      AuthUsecase(AuthRepositoryImpl(FirebaseAuthServiceImpl()));

  Future<void> getCurrentUserInformation() async {
    try {
      final result = await _authUsecase.getCurrentUserInformation();
      result.fold(
          (l) => emit(state.copyWith(error: l)),
          (r) => emit(state.copyWith(
              user: r,
              state: r.name.isNotEmpty
                  ? AuthenticationState.authenticated
                  : AuthenticationState.unAuthenticated)));
    } catch (e) {
      emit(state.copyWith(error: Failure(message: e.toString())));
    }
  }

  Future<bool> updateUserInformation({required UserEntity user}) async {
    final result = await _authUsecase.updateUserInformation(user: user);
    if (result.isLeft) {
      emit(state.copyWith(user: state.user, error: result.left));
      return false;
    } else {
      getCurrentUserInformation();
      return true;
    }
  }

  Future<void> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final result = await _authUsecase.signUp(
          email: email, password: password, name: name);
      result.fold(
          (l) => emit(state.copyWith(error: l)),
          (r) => emit(state.copyWith(
              user: r, state: AuthenticationState.authenticated)));
    } catch (e) {
      emit(state.copyWith(error: Failure(message: e.toString())));
    }
  }

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      final result = await _authUsecase.signInWithEmailAndPassword(
          email: email, password: password);
      result.fold(
          (l) => emit(state.copyWith(error: l)),
          (r) => emit(state.copyWith(
              user: r, state: AuthenticationState.authenticated)));
    } catch (e) {
      emit(state.copyWith(error: Failure(message: e.toString())));
    }
  }

  Future<void> signOutAndResetSetting() async {
    try {
      await _authUsecase.signOut();
      emit(state.copyWith(
          user: null, state: AuthenticationState.unAuthenticated));
    } catch (e) {
      emit(state.copyWith(error: Failure(message: e.toString())));
    }
    final settingsBox = Hive.box('settings');
    settingsBox.clear();
  }

  void clearError() {
    emit(state.copyWith(user: state.user));
  }

  Future<bool> updatePassword(
      {required String currentPassword, required String newPassword}) async {
    final result = await _authUsecase.updatePassword(
        currentPassword: currentPassword, newPassword: newPassword);
    if (result.isRight) {
      emit(state.copyWith(user: state.user));
      return true;
    } else {
      emit(state.copyWith(user: state.user, error: result.left));
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    return await _authUsecase.sendResetPasswordEmail(email);
  }
}
