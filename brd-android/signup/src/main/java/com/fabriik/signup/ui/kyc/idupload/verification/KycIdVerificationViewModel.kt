package com.fabriik.signup.ui.kyc.idupload.verification

import android.app.Application
import com.fabriik.signup.R
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadContract
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadViewModel
import com.fabriik.signup.ui.kyc.idupload.KycUploadPhotoType

class KycIdVerificationViewModel(
    application: Application
) : KycBaseIdUploadViewModel(application) {

    override fun createInitialState() = KycBaseIdUploadContract.State(
        title = R.string.KycIdVerification_Title,
        description = R.string.KycIdVerification_Description,
        photoType = KycUploadPhotoType.VERIFICATION,
        kycStepProgress = 5
    )
}