package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikUiEffect

sealed class LogInUiEffect : FabriikUiEffect {
    object GoToSignUp: LogInUiEffect()
    object GoToForgotPassword : LogInUiEffect()
    class ShowLoading(val show: Boolean) : LogInUiEffect()
    class ShowSnackBar(val message: String) : LogInUiEffect()
}