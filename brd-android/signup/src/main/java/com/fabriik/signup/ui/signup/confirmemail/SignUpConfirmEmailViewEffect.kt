package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class SignUpConfirmEmailViewEffect : FabriikViewEffect {
    object GoToLogin : SignUpConfirmEmailViewEffect()
    class ShowSnackBar(val message: String) : SignUpConfirmEmailViewEffect()
}