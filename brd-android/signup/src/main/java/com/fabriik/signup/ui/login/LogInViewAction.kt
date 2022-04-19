package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class LogInViewAction : FabriikViewAction {
    object InputChanged: LogInViewAction()
    object SubmitClicked: LogInViewAction()
    object SignUpClicked: LogInViewAction()
    object ForgotPasswordClicked: LogInViewAction()
}