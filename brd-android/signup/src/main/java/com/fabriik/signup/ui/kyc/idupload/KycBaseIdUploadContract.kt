package com.fabriik.signup.ui.kyc.idupload

import android.net.Uri
import com.fabriik.signup.ui.base.FabriikContract

interface KycBaseIdUploadContract {

    sealed class Event : FabriikContract.Event {
        object NextClicked: Event()
        object RetryClicked: Event()
        object TakePhotoClicked: Event()
    }

    sealed class Effect : FabriikContract.Effect {
        class GoToNextStep(val imageUri: Uri) : Effect()
        class ShowPreview(val imageUri: Uri) : Effect()
    }

    data class State(
        val nextEnabled: Boolean = false,
        val retryEnabled: Boolean = false,
        val takePhotoEnabled: Boolean = true
    ): FabriikContract.State
}