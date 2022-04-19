package com.fabriik.signup.ui.signup

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class SignUpViewEffect : FabriikViewEffect {
    class GoToConfirmation(val sessionKey: String) : SignUpViewEffect()
    class OpenWebsite(val url: String) : SignUpViewEffect()
}