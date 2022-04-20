package com.fabriik.signup.ui.login

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
import com.fabriik.signup.databinding.FragmentLogInBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.SnackBarUtils
import com.fabriik.signup.utils.clickableSpan
import com.fabriik.signup.utils.setValidator
import com.fabriik.signup.utils.underline
import com.fabriik.signup.utils.validators.EmailValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import kotlinx.coroutines.launch

class LogInFragment : Fragment(), FabriikView<LogInViewState, LogInViewEffect> {

    private lateinit var binding: FragmentLogInBinding
    private val viewModel: LogInViewModel by lazy {
        ViewModelProvider(this).get(LogInViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_log_in, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentLogInBinding.bind(view)

        binding.tvForgotPassword.underline()
        binding.tvForgotPassword.setOnClickListener {
            lifecycleScope.launch {
                viewModel.actions.send(
                    LogInViewAction.ForgotPasswordClicked
                )
            }
        }

        binding.tvNoAccount.clickableSpan(
            fullTextRes = R.string.LogIn_NoAccount,
            clickableParts = mapOf(
                R.string.LogIn_SignUp to {
                    lifecycleScope.launch {
                        viewModel.actions.send(
                            LogInViewAction.SignUpClicked
                        )
                    }
                }
            )
        )

        binding.btnSubmit.setOnClickListener {
            lifecycleScope.launch {
                viewModel.actions.send(
                    LogInViewAction.SubmitClicked(
                        email = binding.etEmail.text.toString(),
                        password = binding.etPassword.text.toString(),
                    )
                )
            }
        }

        binding.etEmail.setValidator(EmailValidator)
        binding.etPassword.setValidator(PasswordValidator)

        viewModel.state.observe(viewLifecycleOwner) {
            render(it)
        }

        viewModel.effect.observe(viewLifecycleOwner) {
            handleEffect(it)
        }
    }

    override fun render(state: LogInViewState) {
        with(state) {
            //todo: loading
        }
    }

    override fun handleEffect(effect: LogInViewEffect?) {
        when (effect) {
            LogInViewEffect.GoToSignUp -> {
                findNavController().navigate(
                    LogInFragmentDirections.actionSignUp()
                )
            }
            LogInViewEffect.GoToForgotPassword -> {
                /*findNavController().navigate(
                    LogInFragmentDirections.actionForgotPassword()
                )*/ //todo: enable when forgot password is ready
            }
            is LogInViewEffect.ShowSnackBar -> {
                SnackBarUtils.showLong(
                    view = binding.root,
                    text = effect.message
                )
            }
        }
    }
}