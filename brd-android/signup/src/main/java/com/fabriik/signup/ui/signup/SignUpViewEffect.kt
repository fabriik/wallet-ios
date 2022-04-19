package com.fabriik.signup.ui.signup

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class SignUpViewEffect : FabriikViewEffect {
    object GoToConfirmation : SignUpViewEffect()
    class OpenWebsite(url: String) : SignUpViewEffect()
}