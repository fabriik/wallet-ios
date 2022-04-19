package com.fabriik.signup.ui.signup

import com.fabriik.signup.ui.base.FabriikViewAction

sealed class SignUpViewAction : FabriikViewAction {
    object InputChanged: SignUpViewAction()
    object SubmitClicked: SignUpViewAction()
    object UserAgreementClicked: SignUpViewAction()
    object PrivacyPolicyClicked: SignUpViewAction()
}