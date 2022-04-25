package com.fabriik.signup.ui.kyc.idupload.back

import androidx.annotation.StringRes
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadFragment
import com.fabriik.signup.ui.kyc.idupload.KycUploadPhotoType

class KycIdUploadBackFragment : KycBaseIdUploadFragment(){

    override fun getKycFlowStep() = 4

    override fun getPhotoType() = KycUploadPhotoType.BACK_SIDE

    @StringRes
    override fun getUploadTitle() = R.string.KycIdUploadBack_Title

    @StringRes
    override fun getUploadDescription() = R.string.KycIdUploadBack_Description

    override fun goToNextStep() {
        findNavController().navigate(
            KycIdUploadBackFragmentDirections.actionIdVerification()
        )
    }
}