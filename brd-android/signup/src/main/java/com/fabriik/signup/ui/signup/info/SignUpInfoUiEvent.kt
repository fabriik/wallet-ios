package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikUiEvent

sealed class SignUpInfoUiEvent : FabriikUiEvent {
    object UserAgreementClicked: SignUpInfoUiEvent()
    object PrivacyPolicyClicked: SignUpInfoUiEvent()
    class SubmitClicked(
        val email: String,
        val password: String,
        val firstName: String,
        val lastName: String,
        val phone: String,
        val termsAccepted: Boolean
    ): SignUpInfoUiEvent()
}