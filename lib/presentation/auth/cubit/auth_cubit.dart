import 'package:bloc/bloc.dart';
import 'package:flutter_pet_shop_app/core/constants/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/error/failure.dart';
import 'package:flutter_pet_shop_app/data/datasource/firebase_auth_service.dart';
import 'package:flutter_pet_shop_app/data/repository/auth_repository.dart';
import 'package:flutter_pet_shop_app/domain/usecases/auth_usecase.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';

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
              user: r, state: AuthenticationState.authenticated)));
    } catch (e) {
      emit(state.copyWith(error: Failure(e.toString())));
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
      emit(state.copyWith(error: Failure(e.toString())));
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
      emit(state.copyWith(error: Failure(e.toString())));
    }
  }

  Future<void> signOut() async {
    try {
      await _authUsecase.signOut();
      emit(state.copyWith(state: AuthenticationState.unAuthenticated));
    } catch (e) {
      emit(state.copyWith(error: Failure(e.toString())));
    }
  }

  Future<bool> forgotPassword(String email) async {
    return await _authUsecase.sendResetPasswordEmail(email);
  }
}
