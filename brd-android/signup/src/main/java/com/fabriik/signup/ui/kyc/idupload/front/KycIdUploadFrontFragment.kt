package com.fabriik.signup.ui.kyc.idupload.front

import androidx.annotation.StringRes
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadFragment
import com.fabriik.signup.ui.kyc.idupload.KycUploadPhotoType

class KycIdUploadFrontFragment : KycBaseIdUploadFragment(){

    override fun getKycFlowStep() = 3

    override fun getPhotoType() = KycUploadPhotoType.FRONT_SIDE

    @StringRes
    override fun getUploadTitle() = R.string.KycIdUploadFront_Title

    @StringRes
    override fun getUploadDescription() = R.string.KycIdUploadFront_Description

    override fun goToNextStep() {
        findNavController().navigate(
            KycIdUploadFrontFragmentDirections.actionIdUploadBack()
        )
    }
}