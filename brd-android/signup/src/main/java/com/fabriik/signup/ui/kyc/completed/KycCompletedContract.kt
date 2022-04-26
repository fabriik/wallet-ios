package com.fabriik.signup.ui.kyc.completed

import com.fabriik.signup.ui.base.FabriikContract

interface KycCompletedContract {

    sealed class Event : FabriikContract.Event {
        object DoneClicked: Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToLogin : Effect()
    }

    class State: FabriikContract.State
}