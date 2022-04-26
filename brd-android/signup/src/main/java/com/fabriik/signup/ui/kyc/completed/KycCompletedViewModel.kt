package com.fabriik.signup.ui.kyc.completed

import android.app.Application
import com.fabriik.signup.ui.base.FabriikViewModel

class KycCompletedViewModel(
    application: Application
) : FabriikViewModel<KycCompletedContract.State, KycCompletedContract.Event, KycCompletedContract.Effect>(application) {

    override fun createInitialState() = KycCompletedContract.State()

    override fun handleEvent(event: KycCompletedContract.Event) {
        when (event) {
            is KycCompletedContract.Event.DoneClicked -> {
                setEffect {
                    KycCompletedContract.Effect.GoToLogin
                }
            }
        }
    }
}