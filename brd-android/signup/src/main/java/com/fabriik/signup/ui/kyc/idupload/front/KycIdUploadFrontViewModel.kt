package com.fabriik.signup.ui.kyc.idupload.front

import android.app.Application
import com.fabriik.signup.R
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadContract
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadViewModel
import com.fabriik.signup.ui.kyc.idupload.KycUploadPhotoType

class KycIdUploadFrontViewModel(
    application: Application
) : KycBaseIdUploadViewModel(application) {

    override fun createInitialState() = KycBaseIdUploadContract.State(
        title = R.string.KycIdUploadFront_Title,
        description = R.string.KycIdUploadFront_Description,
        photoType = KycUploadPhotoType.FRONT_SIDE,
        kycStepProgress = 3
    )
}