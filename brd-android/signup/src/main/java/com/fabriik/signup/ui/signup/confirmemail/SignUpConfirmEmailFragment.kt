package com.fabriik.signup.ui.signup.confirmemail

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentSignUpConfirmEmailBinding
import com.fabriik.signup.ui.SignupActivity
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.ui.signup.info.SignUpInfoViewEffect
import com.fabriik.signup.utils.SnackBarUtils
import com.fabriik.signup.utils.hideKeyboard
import com.fabriik.signup.utils.setValidator
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import kotlinx.coroutines.launch

class SignUpConfirmEmailFragment : Fragment(), FabriikView<SignUpConfirmEmailViewState, SignUpConfirmEmailViewEffect> {

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

        binding.etCode.setValidator(ConfirmationCodeValidator)

        binding.btnConfirm.setOnClickListener {
            hideKeyboard()
            lifecycleScope.launch {
                viewModel.actions.send(
                    SignUpConfirmEmailViewAction.ConfirmClicked(
                        binding.etCode.text.toString()
                    )
                )
            }
        }

        binding.tvResend.setOnClickListener {
            lifecycleScope.launch {
                viewModel.actions.send(
                    SignUpConfirmEmailViewAction.ResendCodeClicked
                )
            }
        }

        viewModel.state.observe(viewLifecycleOwner) {
            render(it)
        }

        viewModel.effect.observe(viewLifecycleOwner) {
            handleEffect(it)
        }
    }

    override fun render(state: SignUpConfirmEmailViewState) {
        //empty
    }

    override fun handleEffect(effect: SignUpConfirmEmailViewEffect?) {
        when (effect) {
            is SignUpConfirmEmailViewEffect.GoToLogin -> {
                findNavController().navigate(
                    SignUpConfirmEmailFragmentDirections.actionLogIn()
                )
            }
            is SignUpConfirmEmailViewEffect.ShowLoading -> {
                val activity = activity as SignupActivity?
                activity?.showLoading(effect.show)
            }
            is SignUpConfirmEmailViewEffect.ShowSnackBar -> {
                SnackBarUtils.showLong(
                    view = binding.root,
                    text = effect.message
                )
            }
        }
    }
}