package com.fabriik.signup.ui.kyc.idupload

import android.app.Application
import androidx.lifecycle.viewModelScope
import com.fabriik.signup.R
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class KycBaseIdUploadViewModel(
    application: Application
) : FabriikViewModel<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Event, KycBaseIdUploadContract.Effect>(
    application
) {

    override fun createInitialState() = KycBaseIdUploadContract.State()

    // todo: request camera permission

    override fun handleEvent(event: KycBaseIdUploadContract.Event) {
        when (event) {
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
                onNextClicked()

            is KycBaseIdUploadContract.Event.RetryClicked ->
                setState {
                    copy(
                        imageUri = null,
                        nextEnabled = false,
                        retryEnabled = false,
                        takePhotoEnabled = true,
                    )
                }

            is KycBaseIdUploadContract.Event.TakePhotoClicked ->
                setEffect {
                    KycBaseIdUploadContract.Effect.TakePhoto
                }
        }
    }

    private fun onNextClicked() {
        viewModelScope.launch(Dispatchers.IO) {
            setEffect {
                KycBaseIdUploadContract.Effect.ShowLoading(true)
            }

            Thread.sleep(2000) // todo: call API

            setEffect {
                KycBaseIdUploadContract.Effect.ShowLoading(false)
            }

            setEffect {
                if (currentState.imageUri == null) {
                    KycBaseIdUploadContract.Effect.ShowSnackBar(
                        getString(R.string.KycIdUpload_DefaultErrorMessage)
                    )
                } else {
                    KycBaseIdUploadContract.Effect.GoToNextStep
                }
            }
        }
    }
}