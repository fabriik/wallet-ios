package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class SignUpInfoViewAction : FabriikViewAction {
    object InputChanged: SignUpInfoViewAction()
    object UserAgreementClicked: SignUpInfoViewAction()
    object PrivacyPolicyClicked: SignUpInfoViewAction()
    class SubmitClicked(
        val email: String,
        val password: String,
        val firstName: String,
        val lastName: String,
        val phone: String,
    ): SignUpInfoViewAction()
}