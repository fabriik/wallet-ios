package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class SignUpConfirmEmailViewAction : FabriikViewAction {
    object InputChanged: SignUpConfirmEmailViewAction()
    object ResendCodeClicked: SignUpConfirmEmailViewAction()
    class ConfirmClicked(
        val confirmationCode: String
    ): SignUpConfirmEmailViewAction()
}