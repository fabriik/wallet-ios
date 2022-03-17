import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => const [];
}

class InitialLoginState extends LoginState {
  @override
  String toString() {
    return '${(InitialLoginState).toString()}{}';
  }
}

class LoginLoadingState extends LoginState {
  @override
  String toString() {
    return '${(LoginLoadingState).toString()}{}';
  }
}

class LoginErrorState extends LoginState {

  LoginErrorState({required this.error});

  final String error;

  @override
  String toString() {
    return '${(LoginErrorState).toString()}{error: $error}';
  }
}

class LoginSuccessState extends LoginState {
  final String sessionKey;
  LoginSuccessState({
    required this.sessionKey,
  });
  @override
  String toString() {
    return '${(LoginSuccessState)}{}';
  }
}

class ResetPasswordSuccessState extends LoginState {
  @override
  String toString() {
    return '${(ResetPasswordSuccessState).toString()}{}';
  }
}

class SignUpEventSuccessState extends LoginState {
  final String sessionKey;

  SignUpEventSuccessState(this.sessionKey);

  @override
  String toString() {
    return '${(SignUpEventSuccessState).toString()}{}';
  }
}
