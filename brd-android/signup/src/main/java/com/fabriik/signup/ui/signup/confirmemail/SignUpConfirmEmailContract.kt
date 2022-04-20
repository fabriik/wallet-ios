package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikContract

interface SignUpConfirmEmailContract {

    sealed class Event : FabriikContract.Event {
        object ResendCodeClicked: Event()
        class ConfirmClicked(
            val confirmationCode: String
        ): Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToLogin : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State: FabriikContract.State
}