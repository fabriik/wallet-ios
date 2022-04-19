package com.fabriik.signup.ui.login

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.core.widget.doAfterTextChanged
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentLogInBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.ui.confirmemail.ConfirmEmailViewEffect
import com.fabriik.signup.ui.confirmemail.ConfirmEmailViewState
import com.fabriik.signup.utils.clickableSpan
import com.fabriik.signup.utils.setInputValid
import com.fabriik.signup.utils.underline

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
        binding.tvNoAccount.clickableSpan(
            fullTextRes = R.string.LogIn_NoAccount,
            clickableParts = mapOf(
                R.string.LogIn_SignUp to {
                    findNavController().navigate(
                        LogInFragmentDirections.actionSignUp()
                    )
                }
            )
        )

        binding.btnSubmit.setOnClickListener {

        }

        //todo: remove
        binding.etEmail.doAfterTextChanged {
            binding.etEmail.setInputValid(
                it?.length ?: 0 > 4
            )
        }

        //todo: remove
        binding.etPassword.doAfterTextChanged {
            binding.etPassword.setInputValid(
                it?.length ?: 0 > 8
            )
        }
    }

    override fun render(state: LogInViewState) {
        TODO("Not yet implemented")
    }

    override fun handleEffect(effect: LogInViewEffect?) {
        TODO("Not yet implemented")
    }
}