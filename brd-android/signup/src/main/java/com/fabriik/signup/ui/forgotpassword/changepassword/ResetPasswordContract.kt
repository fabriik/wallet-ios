package com.fabriik.signup.ui.forgotpassword.changepassword

import com.fabriik.signup.ui.base.FabriikContract

interface ResetPasswordContract {

    sealed class Event : FabriikContract.Event {
        class ConfirmClicked(
            val code: String,
            val password: String,
            val passwordConfirm: String
        ): Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object GoToResetCompleted : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State: FabriikContract.State
}