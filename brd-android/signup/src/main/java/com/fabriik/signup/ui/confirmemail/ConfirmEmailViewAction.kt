package com.fabriik.signup.ui.confirmemail

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class ConfirmEmailViewAction : FabriikViewAction {
    object InputChanged: ConfirmEmailViewAction()
    object ConfirmClicked: ConfirmEmailViewAction()
    object ResendCodeClicked: ConfirmEmailViewAction()
}