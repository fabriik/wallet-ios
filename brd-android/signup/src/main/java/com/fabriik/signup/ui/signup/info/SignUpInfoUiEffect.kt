package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikUiEffect

sealed class SignUpInfoUiEffect : FabriikUiEffect {
    class GoToConfirmation(val sessionKey: String) : SignUpInfoUiEffect()
    class OpenWebsite(val url: String) : SignUpInfoUiEffect()
    class ShowLoading(val show: Boolean) : SignUpInfoUiEffect()
    class ShowSnackBar(val message: String) : SignUpInfoUiEffect()
}