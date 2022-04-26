package com.fabriik.signup.ui.kyc.idupload.back

import android.app.Application
import com.fabriik.signup.R
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadContract
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadViewModel
import com.fabriik.signup.ui.kyc.idupload.KycUploadPhotoType

class KycIdUploadBackViewModel(
    application: Application
) : KycBaseIdUploadViewModel(application) {

    override fun createInitialState() = KycBaseIdUploadContract.State(
        title = R.string.KycIdUploadBack_Title,
        description = R.string.KycIdUploadBack_Description,
        photoType = KycUploadPhotoType.BACK_SIDE,
        kycStepProgress = 4
    )
}