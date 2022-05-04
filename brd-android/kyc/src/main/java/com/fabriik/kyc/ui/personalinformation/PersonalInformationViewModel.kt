package com.fabriik.kyc.ui.personalinformation

import android.app.Application
import com.fabriik.common.ui.base.FabriikViewModel

class PersonalInformationViewModel(
    application: Application
) : FabriikViewModel<PersonalInformationContract.State, PersonalInformationContract.Event, PersonalInformationContract.Effect>(application) {

    override fun createInitialState() = PersonalInformationContract.State()

    override fun handleEvent(event: PersonalInformationContract.Event) {
        when (event) {

        }
    }
}