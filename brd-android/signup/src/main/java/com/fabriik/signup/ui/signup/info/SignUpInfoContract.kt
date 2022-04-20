package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikUiEffect
import com.fabriik.signup.ui.base.FabriikUiEvent
import com.fabriik.signup.ui.base.FabriikUiState

interface SignUpInfoContract {

    sealed class Event : FabriikUiEvent {
        object UserAgreementClicked: Event()
        object PrivacyPolicyClicked: Event()
        class SubmitClicked(
            val email: String,
            val password: String,
            val firstName: String,
            val lastName: String,
            val phone: String,
            val termsAccepted: Boolean
        ): Event()
    }

    sealed class Effect : FabriikUiEffect {
        class GoToConfirmation(val sessionKey: String) : Effect()
        class OpenWebsite(val url: String) : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State : FabriikUiState
}