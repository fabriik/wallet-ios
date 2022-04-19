package com.fabriik.signup.ui.signup

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class SignUpViewAction : FabriikViewAction {
    object InputChanged: SignUpViewAction()
    object UserAgreementClicked: SignUpViewAction()
    object PrivacyPolicyClicked: SignUpViewAction()
    class SubmitClicked(
        val email: String,
        val password: String,
        val firstName: String,
        val lastName: String,
        val phone: String,
    ): SignUpViewAction()
}