package com.fabriik.signup.ui.forgotpassword.reset

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentResetPasswordBinding
import com.fabriik.signup.ui.SignupActivity
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.SnackBarUtils
import com.fabriik.signup.utils.hideKeyboard
import com.fabriik.signup.utils.setValidator
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import kotlinx.coroutines.flow.collect

class ResetPasswordFragment : Fragment(),
    FabriikView<ResetPasswordContract.State, ResetPasswordContract.Effect> {

    private lateinit var binding: FragmentResetPasswordBinding
    private val viewModel: ResetPasswordViewModel by lazy {
        ViewModelProvider(this).get(ResetPasswordViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_reset_password, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentResetPasswordBinding.bind(view)

        with(binding) {

            // setup input fields
            etCode.setValidator(ConfirmationCodeValidator)
            etNewPassword.setValidator(PasswordValidator)
            etConfirmPassword.setValidator(PasswordValidator)

            // setup "Confirm" button
            btnConfirm.setOnClickListener {
                hideKeyboard()

                viewModel.setEvent(
                    ResetPasswordContract.Event.ConfirmClicked(
                        code = binding.etCode.text.toString(),
                        password = binding.etNewPassword.text.toString(),
                        passwordConfirm = binding.etConfirmPassword.text.toString()
                    )
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

    override fun render(state: ResetPasswordContract.State) {
        //empty
    }

    override fun handleEffect(effect: ResetPasswordContract.Effect) {
        when (effect) {
            is ResetPasswordContract.Effect.GoToResetCompleted -> {
                findNavController().navigate(
                    ResetPasswordFragmentDirections.actionResetCompleted()
                )
            }
            is ResetPasswordContract.Effect.ShowLoading -> {
                val activity = activity as SignupActivity?
                activity?.showLoading(effect.show)
            }
            is ResetPasswordContract.Effect.ShowSnackBar -> {
                SnackBarUtils.showLong(
                    view = binding.root,
                    text = effect.message
                )
            }
        }
    }
}