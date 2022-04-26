package com.fabriik.signup.ui.kyc.idupload

import android.app.Application
import android.net.Uri
import com.fabriik.signup.R
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString

class KycBaseIdUploadViewModel(
    application: Application
) : FabriikViewModel<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Event, KycBaseIdUploadContract.Effect>(
    application
) {

    override fun createInitialState() = KycBaseIdUploadContract.State()

    // todo: request camera permission

    override fun handleEvent(event: KycBaseIdUploadContract.Event) {
        when (event) {
            is KycBaseIdUploadContract.Event.FragmentStarted ->
                setEffect {
                    if (currentState.imageUri == null) {
                        KycBaseIdUploadContract.Effect.ShowCameraPreview
                    } else {
                        KycBaseIdUploadContract.Effect.ShowImagePreview(
                            currentState.imageUri!!
                        )
                    }
                }

            is KycBaseIdUploadContract.Event.TakePhotoFailed ->
                setEffect {
                    KycBaseIdUploadContract.Effect.ShowSnackBar(
                        getString(R.string.KycIdUpload_DefaultErrorMessage)
                    )
                }

            is KycBaseIdUploadContract.Event.TakePhotoCompleted ->
                setState {
                    copy(
                        imageUri = event.uri,
                        nextEnabled = true,
                        retryEnabled = true,
                        takePhotoEnabled = false
                    )
                }

            is KycBaseIdUploadContract.Event.SwitchCameraClicked ->
                setEffect {
                    KycBaseIdUploadContract.Effect.SwitchCamera
                }

            is KycBaseIdUploadContract.Event.NextClicked ->
                setEffect {
                    if (currentState.imageUri == null) {
                        KycBaseIdUploadContract.Effect.ShowSnackBar(
                            getString(R.string.KycIdUpload_DefaultErrorMessage)
                        )
                    } else {
                        KycBaseIdUploadContract.Effect.GoToNextStep(
                            currentState.imageUri!!
                        )
                    }
                }

            is KycBaseIdUploadContract.Event.RetryClicked -> {
                setState {
                    copy(
                        imageUri = null,
                        nextEnabled = false,
                        retryEnabled = false,
                        takePhotoEnabled = true,
                    )
                }

                setEffect {
                    KycBaseIdUploadContract.Effect.ShowCameraPreview
                }
            }

            is KycBaseIdUploadContract.Event.TakePhotoClicked ->
                setEffect {
                    KycBaseIdUploadContract.Effect.TakePhoto
                }
        }
    }
}