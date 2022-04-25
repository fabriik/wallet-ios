package com.fabriik.signup.ui.kyc.idupload

import android.app.Application
import android.net.Uri
import com.fabriik.signup.ui.base.FabriikViewModel

class KycBaseIdUploadViewModel(
    application: Application
) : FabriikViewModel<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Event, KycBaseIdUploadContract.Effect>(application) {

    override fun createInitialState() = KycBaseIdUploadContract.State()

    override fun handleEvent(event: KycBaseIdUploadContract.Event) {
        when (event) {
            is KycBaseIdUploadContract.Event.NextClicked -> {
                setEffect {
                    KycBaseIdUploadContract.Effect.GoToNextStep(
                        //todo: get uri
                        Uri.parse("file://test.jpg")
                    )
                }
            }

            is KycBaseIdUploadContract.Event.RetryClicked -> {
                //todo: clear current uri

                setState {
                    copy(
                        nextEnabled = false,
                        retryEnabled = false,
                        takePhotoEnabled = true,
                    )
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