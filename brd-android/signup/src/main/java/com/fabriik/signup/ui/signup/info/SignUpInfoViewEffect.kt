package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikViewEffect

sealed class SignUpInfoViewEffect : FabriikViewEffect {
    class GoToConfirmation(val sessionKey: String) : SignUpInfoViewEffect()
    class OpenWebsite(val url: String) : SignUpInfoViewEffect()
}