package com.fabriik.signup.ui.signup.confirmemail

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentSignUpConfirmEmailBinding
import com.fabriik.signup.ui.SignupActivity
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.SnackBarUtils
import com.fabriik.signup.utils.hideKeyboard
import com.fabriik.signup.utils.setValidator
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class SignUpConfirmEmailFragment : Fragment(),
    FabriikView<SignUpConfirmEmailUiState, SignUpConfirmEmailUiEffect> {

    private lateinit var binding: FragmentSignUpConfirmEmailBinding
    private val viewModel: SignUpConfirmEmailViewModel by lazy {
        ViewModelProvider(this).get(SignUpConfirmEmailViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_sign_up_confirm_email, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSignUpConfirmEmailBinding.bind(view)

        with(binding) {

            // setup input field
            etCode.setValidator(ConfirmationCodeValidator)

            // setup "Confirm" button
            btnConfirm.setOnClickListener {
                hideKeyboard()

                viewModel.setEvent(
                    SignUpConfirmEmailUiEvent.ConfirmClicked(
                        binding.etCode.text.toString()
                    )
                )
            }

            // setup "Resend code" button
            tvResend.setOnClickListener {
                viewModel.setEvent(
                    SignUpConfirmEmailUiEvent.ResendCodeClicked
                )
            }
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

    override fun render(state: SignUpConfirmEmailUiState) {
        //empty
    }

    override fun handleEffect(effect: SignUpConfirmEmailUiEffect?) {
        when (effect) {
            is SignUpConfirmEmailUiEffect.GoToLogin -> {
                findNavController().navigate(
                    SignUpConfirmEmailFragmentDirections.actionLogIn()
                )
            }
            is SignUpConfirmEmailUiEffect.ShowLoading -> {
                val activity = activity as SignupActivity?
                activity?.showLoading(effect.show)
            }
            is SignUpConfirmEmailUiEffect.ShowSnackBar -> {
                SnackBarUtils.showLong(
                    view = binding.root,
                    text = effect.message
                )
            }
        }
    }
}