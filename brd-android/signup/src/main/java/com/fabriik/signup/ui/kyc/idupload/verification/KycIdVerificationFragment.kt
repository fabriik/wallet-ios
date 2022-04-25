package com.fabriik.signup.ui.kyc.idupload.verification

import androidx.annotation.StringRes
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadFragment
import com.fabriik.signup.ui.kyc.idupload.KycUploadPhotoType

class KycIdVerificationFragment : KycBaseIdUploadFragment(){

    override fun getKycFlowStep() = 5

    override fun getPhotoType() = KycUploadPhotoType.VERIFICATION

    @StringRes
    override fun getUploadTitle() = R.string.KycIdVerification_Title

    @StringRes
    override fun getUploadDescription() = R.string.KycIdVerification_Description

    override fun goToNextStep() {
        findNavController().navigate(
            KycIdVerificationFragmentDirections.actionKycCompleted()
        )
    }
}