package com.fabriik.signup.ui.kyc.idupload.front

import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.ui.kyc.idupload.KycBaseIdUploadFragment

class KycIdUploadFrontFragment : KycBaseIdUploadFragment<KycIdUploadFrontViewModel>(){

    override val viewModel: KycIdUploadFrontViewModel by lazy {
        ViewModelProvider(this).get(KycIdUploadFrontViewModel::class.java)
    }

    override fun goToNextStep() {
        findNavController().navigate(
            KycIdUploadFrontFragmentDirections.actionIdUploadBack()
        )
    }
}