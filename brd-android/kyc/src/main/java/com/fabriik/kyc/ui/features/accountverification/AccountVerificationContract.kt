package com.fabriik.kyc.ui.features.accountverification

import com.fabriik.common.ui.base.FabriikContract

interface AccountVerificationContract {

    sealed class Event : FabriikContract.Event {

    }

    sealed class Effect : FabriikContract.Effect {

    }

    class State() : FabriikContract.State //todo: data class
}