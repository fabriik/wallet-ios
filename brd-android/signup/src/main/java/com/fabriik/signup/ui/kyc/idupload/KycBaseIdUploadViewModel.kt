package com.fabriik.signup.ui.kyc.idupload

import android.app.Application
import android.net.Uri
import com.fabriik.signup.ui.base.FabriikViewModel

class KycBaseIdUploadViewModel(
    application: Application
) : FabriikViewModel<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Event, KycBaseIdUploadContract.Effect>(
    application
) {

    override fun createInitialState() = KycBaseIdUploadContract.State()

    // todo: request camera permission

    override fun handleEvent(event: KycBaseIdUploadContract.Event) {
        when (event) {
            is KycBaseIdUploadContract.Event.FragmentStarted -> {
                setEffect {
                    if (currentState.imageUri == null) {
                        KycBaseIdUploadContract.Effect.ShowCameraPreview
                    } else {
                        KycBaseIdUploadContract.Effect.ShowImagePreview(
                            currentState.imageUri!!
                        )
                    }
                }
            }

            is KycBaseIdUploadContract.Event.TakePhotoFailed -> {
                setEffect {
                    KycBaseIdUploadContract.
                }
            }

            is KycBaseIdUploadContract.Event.TakePhotoCompleted ->
                setState {
                    copy(
                        imageUri = event.uri,
                        nextEnabled = false,
                        retryEnabled = false,
                        takePhotoEnabled = true
                    )
                }

            is KycBaseIdUploadContract.Event.NextClicked -> {
                setEffect {
                    KycBaseIdUploadContract.Effect.GoToNextStep(
                        //todo: get uri
                        Uri.parse("file://test.jpg")
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

            is KycBaseIdUploadContract.Event.TakePhotoClicked -> {
                //todo: get uri
                val imageUri = Uri.parse("file://test.jpg")

                setState {
                    copy(
                        nextEnabled = imageUri != null,
                        retryEnabled = imageUri != null,
                        takePhotoEnabled = imageUri == null,
                    )
                }
            }
        }
    }
}