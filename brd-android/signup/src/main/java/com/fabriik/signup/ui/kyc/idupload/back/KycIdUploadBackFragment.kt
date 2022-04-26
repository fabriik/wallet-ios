package com.fabriik.signup.ui.kyc.idupload.back

import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadFragment

class KycIdUploadBackFragment : KycBaseIdUploadFragment<KycIdUploadBackViewModel>(){

    override val viewModel: KycIdUploadBackViewModel by lazy {
        ViewModelProvider(this).get(KycIdUploadBackViewModel::class.java)
    }

    override fun goToNextStep() {
        findNavController().navigate(
            KycIdUploadBackFragmentDirections.actionIdVerification()
        )
    }
}