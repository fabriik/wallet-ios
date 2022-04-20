package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikContract

interface LogInContract {

    sealed class Event : FabriikContract.Event {
        object SignUpClicked : Event()
        object ForgotPasswordClicked : Event()
        class SubmitClicked(
            val email: String,
            val password: String
        ) : Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToSignUp : Effect()
        object GoToForgotPassword : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State : FabriikContract.State
}