package com.fabriik.signup.ui.kyc.idupload

import android.net.Uri
import com.fabriik.signup.ui.base.FabriikContract

interface KycBaseIdUploadContract {

    sealed class Event : FabriikContract.Event {
        object NextClicked: Event()
        object RetryClicked: Event()
        object TakePhotoClicked: Event()
        object SwitchCameraClicked: Event()
        object TakePhotoFailed: Event()
        class TakePhotoCompleted(val uri: Uri): Event()
    }

    sealed class Effect : FabriikContract.Effect {
        object SwitchCamera : Effect()
        object GoToNextStep : Effect()
        class ShowSnackBar(val message: String) : Effect()
        class ShowLoading(val show: Boolean) : Effect()
        class TakePhoto(val type: KycUploadPhotoType) : Effect()
    }

    data class State(
        val title: Int,
        val description: Int,
        val kycStepProgress: Int,
        val photoType: KycUploadPhotoType,
        val imageUri: Uri? = null,
        val nextEnabled: Boolean = false,
        val retryEnabled: Boolean = false,
        val takePhotoEnabled: Boolean = true,
        val switchCameraVisible: Boolean = false // todo: set value
    ): FabriikContract.State
}