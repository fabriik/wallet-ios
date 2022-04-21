package com.fabriik.signup.ui.forgotpassword.completed

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentResetPasswordCompletedBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.hideKeyboard
import com.fabriik.signup.utils.setValidator
import com.fabriik.signup.utils.validators.EmailValidator
import kotlinx.coroutines.flow.collect

class ResetPasswordCompletedFragment : Fragment(),
    FabriikView<ResetPasswordCompletedContract.State, ResetPasswordCompletedContract.Effect> {

    private lateinit var binding: FragmentResetPasswordCompletedBinding
    private val viewModel: ResetPasswordCompletedViewModel by lazy {
        ViewModelProvider(this).get(ResetPasswordCompletedViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_reset_password_completed, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentResetPasswordCompletedBinding.bind(view)

        with(binding) {

            // setup input field
            etEmail.setValidator(EmailValidator)

            // setup "Submit" button
            btnSubmit.setOnClickListener {
                hideKeyboard()

                viewModel.setEvent(
                    ResetPasswordCompletedContract.Event.LoginClicked
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

    override fun render(state: ResetPasswordCompletedContract.State) {
        //empty
    }

    override fun handleEffect(effect: ResetPasswordCompletedContract.Effect) {
        when (effect) {
            is ResetPasswordCompletedContract.Effect.GoToLogin -> {
                findNavController().navigate(
                    ResetPasswordCompletedFragmentDirections.actionLogIn()
                )
            }
        }
    }
}