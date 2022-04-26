package com.fabriik.signup.ui.kyc.idupload.verification

import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadFragment

class KycIdVerificationFragment : KycBaseIdUploadFragment<KycIdVerificationViewModel>(){

    override val viewModel: KycIdVerificationViewModel by lazy {
        ViewModelProvider(this).get(KycIdVerificationViewModel::class.java)
    }

    override fun goToNextStep() {
        findNavController().navigate(
            KycIdVerificationFragmentDirections.actionKycCompleted()
        )
    }
}