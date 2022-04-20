package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class SignUpInfoViewAction : FabriikViewAction {
    object UserAgreementClicked: SignUpInfoViewAction()
    object PrivacyPolicyClicked: SignUpInfoViewAction()
    class SubmitClicked(
        val email: String,
        val password: String,
        val firstName: String,
        val lastName: String,
        val phone: String,
        val termsAccepted: Boolean
    ): SignUpInfoViewAction()
}