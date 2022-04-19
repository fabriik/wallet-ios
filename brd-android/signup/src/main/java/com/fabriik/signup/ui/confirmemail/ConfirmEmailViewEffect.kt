package com.fabriik.signup.ui.confirmemail

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class ConfirmEmailViewEffect : FabriikViewEffect {
    class FinishWithToastMessage(val message: String) : ConfirmEmailViewEffect()
}