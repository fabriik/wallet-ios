package com.fabriik.signup.ui.forgotpassword.completed

import com.fabriik.signup.ui.base.FabriikContract

interface ResetPasswordCompletedContract {

    sealed class Event : FabriikContract.Event {
        object LoginClicked: Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToLogin : Effect()
    }

    class State: FabriikContract.State
}