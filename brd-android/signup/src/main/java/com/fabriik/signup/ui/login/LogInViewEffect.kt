package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class LogInViewEffect : FabriikViewEffect {
    object GoToSignUp: LogInViewEffect()
    object GoToForgotPassword : LogInViewEffect()
    class ShowToast(val message: String) : LogInViewEffect()
}