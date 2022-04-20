package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikUiEvent

sealed class LogInUiEvent : FabriikUiEvent {
    object SignUpClicked : LogInUiEvent()
    object ForgotPasswordClicked : LogInUiEvent()
    class SubmitClicked(
        val email: String,
        val password: String
    ) : LogInUiEvent()
}