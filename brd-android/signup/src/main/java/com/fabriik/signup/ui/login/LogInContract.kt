package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikUiEffect
import com.fabriik.signup.ui.base.FabriikUiEvent
import com.fabriik.signup.ui.base.FabriikUiState

interface LogInContract {

    sealed class Event : FabriikUiEvent {
        object SignUpClicked : Event()
        object ForgotPasswordClicked : Event()
        class SubmitClicked(
            val email: String,
            val password: String
        ) : Event()
    }

    sealed class Effect : FabriikUiEffect {
        object GoToSignUp : Effect()
        object GoToForgotPassword : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State : FabriikUiState
}