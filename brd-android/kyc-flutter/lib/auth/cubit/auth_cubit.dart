import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kyc/constants/constants.dart';
import 'package:kyc/data/user_repository.dart';
import 'package:kyc/navigation/cubit/navigation_cubit.dart';
import 'package:kyc/utils/session_manager.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {

  AuthCubit({required this.navigationCubit, required this.userRepo})
      : super(AuthUninitializedState());

  final UserRepo userRepo;
  final NavigationCubit navigationCubit;
  final sessionManager = SessionManager();


  void handleAppStarted() async {
    final isUserLoggedIn = await userRepo.isLoggedIn();
    if (isUserLoggedIn) {
      // Check if the session key is still valid
      try {
        if (await userRepo.validateSession()) {
          //set global currency from sharedpreferences
          final currency = await sessionManager.getGlobalCurrency();
          if(currency != null) {
            globalCurrency = VsCurrency.values
                .firstWhere((curr) => curr.value.keys.first == currency)
                .value;
          }
          emit(AuthAuthenticatedState());
          return;
        }
      } on Exception catch (ex) {
        print(ex);
      }
    }

    emit(AuthUnauthenticatedState());
  }

  void handleLoggedIn() async {
    emit(AuthAuthenticatedState());
  }

  void handleLoggedOut() async {
    await userRepo.logout();
    navigationCubit.navigateToLogin();
    emit(AuthUnauthenticatedState());
  }
}