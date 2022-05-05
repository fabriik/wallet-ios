package com.fabriik.kyc.ui.features.personalinformation

import com.fabriik.common.ui.base.FabriikContract

interface PersonalInformationContract {

    sealed class Event : FabriikContract.Event {

    }

    sealed class Effect : FabriikContract.Effect {

    }

    class State() : FabriikContract.State //todo: data class
}