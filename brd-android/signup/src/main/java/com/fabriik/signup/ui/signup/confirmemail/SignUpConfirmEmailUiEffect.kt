package com.fabriik.signup.ui.signup.confirmemail

import com.fabriik.signup.ui.base.FabriikUiEffect

sealed class SignUpConfirmEmailUiEffect : FabriikUiEffect {
    object GoToLogin : SignUpConfirmEmailUiEffect()
    class ShowLoading(val show: Boolean) : SignUpConfirmEmailUiEffect()
    class ShowSnackBar(val message: String) : SignUpConfirmEmailUiEffect()
}