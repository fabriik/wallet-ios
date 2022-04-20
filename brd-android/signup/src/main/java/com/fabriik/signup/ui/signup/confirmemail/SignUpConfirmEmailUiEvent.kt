package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikUiEvent

sealed class SignUpConfirmEmailUiEvent : FabriikUiEvent {
    object ResendCodeClicked: SignUpConfirmEmailUiEvent()
    class ConfirmClicked(
        val confirmationCode: String
    ): SignUpConfirmEmailUiEvent()
}