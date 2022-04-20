package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class LogInViewAction : FabriikViewAction {
    object SignUpClicked : LogInViewAction()
    object ForgotPasswordClicked : LogInViewAction()
    class SubmitClicked(
        val email: String,
        val password: String
    ) : LogInViewAction()
}