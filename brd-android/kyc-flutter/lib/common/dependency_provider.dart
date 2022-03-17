// ignore: must_be_immutable
import 'package:flutter/material.dart';
import 'package:kyc/auth/auth.dart';
import 'package:kyc/data/user_repository.dart';
import 'package:kyc/navigation/navigation.dart';

class DependencyProvider extends InheritedWidget {
  DependencyProvider({Key? key, required Widget child})
      : navigationCubit = NavigationCubit(),
        super(key: key, child: child) {
    userRepo = UserRepo(onSessionExpired: onSessionExpired);
    authCubit = AuthCubit(navigationCubit: navigationCubit, userRepo: userRepo);
  }

  final NavigationCubit navigationCubit;
  late final UserRepo userRepo;
  late final AuthCubit authCubit;

  static DependencyProvider of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<DependencyProvider>();
    assert(result != null, 'No DependencyProvider found in context');
    return result!;
  }

  void dispose() {
    navigationCubit.close();
  }

  Future<void> onSessionExpired() async {
    print('session expired');
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
