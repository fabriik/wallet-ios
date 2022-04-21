package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikContract

interface LogInContract {

    sealed class Event : FabriikContract.Event {
        object SignUpClicked : Event()
        object SubmitClicked : Event()
        object ForgotPasswordClicked : Event()
        class EmailChanged(val email: String) : Event()
        class PasswordChanged(val password: String) : Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToSignUp : Effect()
        object GoToForgotPassword : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    data class State(
        val email: String,
        val password: String,
    ) : FabriikContract.State
}