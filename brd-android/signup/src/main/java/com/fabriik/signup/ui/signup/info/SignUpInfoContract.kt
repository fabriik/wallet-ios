package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikContract

interface SignUpInfoContract {

    sealed class Event : FabriikContract.Event {
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

    sealed class Effect : FabriikContract.Effect {
        class GoToConfirmation(val sessionKey: String) : Effect()
        class OpenWebsite(val url: String) : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class ShowSnackBar(val message: String) : Effect()
    }

    class State : FabriikContract.State
}