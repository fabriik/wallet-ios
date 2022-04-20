package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikUiEffect
import com.fabriik.signup.ui.base.FabriikUiEvent
import com.fabriik.signup.ui.base.FabriikUiState

interface SignUpConfirmEmailContract {

    sealed class Event : FabriikUiEvent {
        object ResendCodeClicked: Event()
        class ConfirmClicked(
            val confirmationCode: String
        ): Event()
    }

    sealed class Effect : FabriikUiEffect {
        object GoToLogin : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State: FabriikUiState
}