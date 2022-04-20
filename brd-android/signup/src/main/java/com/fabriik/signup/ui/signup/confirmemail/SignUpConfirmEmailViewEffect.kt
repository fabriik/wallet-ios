package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class SignUpConfirmEmailViewEffect : FabriikViewEffect {
    class FinishWithToastMessage(val message: String) : SignUpConfirmEmailViewEffect()
}