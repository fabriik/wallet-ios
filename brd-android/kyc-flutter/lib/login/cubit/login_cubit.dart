import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:kyc/auth/cubit/auth_cubit.dart';
import 'package:kyc/data/user_repository.dart';
import 'package:kyc/login/cubit/login_state.dart';
import 'package:kyc/login/login.dart';
import 'package:kyc/models/login_credentials.dart';
import 'package:kyc/models/user.dart';
import 'package:kyc/utils/session_manager.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.authCubit}) : super(InitialLoginState());

  final UserRepo userRepo = UserRepo();
  final sessionManager = SessionManager();
  final AuthCubit authCubit;

  void handleAttemptLogin(LoginCredentials data) async {
    emit(LoginLoadingState());
    try {
      final sessionKey = await userRepo.loginWithEmailPass(data);
      if (sessionKey != null) {
        sessionManager
          ..setUserEmail(data.email!.trim())
          ..persistSessionKey(sessionKey);
        authCubit.handleLoggedIn();
        emit(LoginSuccessState(sessionKey: sessionKey));
      } else {
        emit(LoginErrorState(error: 'Error occured'));
      }
    } on HttpException catch (e) {
      emit(LoginErrorState(error: e.message));
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }

  void handleSignUpEvent(email, password, firstName, lastName, phone) async {
    emit(LoginLoadingState());
    try {
      final sessionKey = await userRepo.signUpWithEmail(
        email,
        password,
        firstName,
        lastName,
        phone,
      );
      if (sessionKey != null) {
        final user = User(firstName, lastName, email, phone);
        sessionManager.setUserData(user);
        await sessionManager.persistSessionKey(sessionKey);
        authCubit.handleLoggedIn();
        emit(SignUpEventSuccessState(sessionKey));
      }
    } on HttpException catch (e) {
      emit(LoginErrorState(error: e.message));
    } catch (e) {
      emit(LoginErrorState(error: e.toString()));
    }
  }
}
