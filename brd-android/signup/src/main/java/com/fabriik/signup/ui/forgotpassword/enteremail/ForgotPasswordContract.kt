package com.fabriik.signup.ui.forgotpassword.enteremail

import com.fabriik.signup.ui.base.FabriikContract

interface ForgotPasswordContract {

    sealed class Event : FabriikContract.Event {
        class ConfirmClicked(
            val email: String
        ): Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToResetPassword : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State: FabriikContract.State
}