import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => const [];
}

class AuthUninitializedState extends AuthState {
  @override
  String toString() {
    return '${(AuthUninitializedState).toString()}{}';
  }
}

class AuthAuthenticatedState extends AuthState {
  @override
  String toString() {
    return '${(AuthAuthenticatedState).toString()}{}';
  }
}

class AuthUnauthenticatedState extends AuthState {
  AuthUnauthenticatedState({this.userEmail});
  final String? userEmail;

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return '${(AuthUnauthenticatedState).toString()}{userEmail: $userEmail}';
  }
}