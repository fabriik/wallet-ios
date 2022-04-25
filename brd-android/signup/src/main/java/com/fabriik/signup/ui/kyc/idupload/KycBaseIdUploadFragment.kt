package com.fabriik.signup.ui.kyc.idupload

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.annotation.IntRange
import androidx.annotation.StringRes
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentKycCompleteBinding
import com.fabriik.signup.databinding.FragmentKycIdUploadBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.hideKeyboard
import kotlinx.coroutines.flow.collect

abstract class KycBaseIdUploadFragment : Fragment(),
    FabriikView<KycBaseIdUploadContract.State, KycBaseIdUploadContract.Effect> {

    private lateinit var binding: FragmentKycIdUploadBinding
    private val viewModel: KycBaseIdUploadViewModel by lazy {
        ViewModelProvider(this).get(KycBaseIdUploadViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_kyc_id_upload, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentKycIdUploadBinding.bind(view)

        with(binding) {
            // setup "Next" button
            btnNext.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.NextClicked
                )
            }

            // setup "Retry" button
            btnRetry.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.RetryClicked
                )
            }

            // setup "Take Photo" button
            btnTakePhoto.setOnClickListener {
                viewModel.setEvent(
                    KycBaseIdUploadContract.Event.TakePhotoClicked
                )
            }

            // setup Progress indicator
            pbIndicator.progress = getKycFlowStep()

            // setup title
            tvTitle.setText(getUploadTitle())

            // setup description
            tvDescription.setText(getUploadDescription())
        }

        // collect UI state
        lifecycleScope.launchWhenStarted {
            viewModel.state.collect {
                render(it)
            }
        }

        // collect UI effect
        lifecycleScope.launchWhenStarted {
            viewModel.effect.collect {
                handleEffect(it)
            }
        }
    }

    override fun render(state: KycBaseIdUploadContract.State) {
        with(binding) {
            btnNext.isEnabled = state.nextEnabled
            btnRetry.isEnabled = state.retryEnabled
            btnTakePhoto.isEnabled = state.takePhotoEnabled
        }
    }

    override fun handleEffect(effect: KycBaseIdUploadContract.Effect) {
        when (effect) {
            is KycBaseIdUploadContract.Effect.GoToNextStep -> goToNextStep()
            is KycBaseIdUploadContract.Effect.ShowPreview -> {} //todo
        }
    }

    @IntRange(from = 3, to = 5)
    protected abstract fun getKycFlowStep() : Int

    protected abstract fun getPhotoType() : KycUploadPhotoType

    @StringRes
    protected abstract fun getUploadTitle() : Int

    @StringRes
    protected abstract fun getUploadDescription() : Int

    protected abstract fun goToNextStep()
}