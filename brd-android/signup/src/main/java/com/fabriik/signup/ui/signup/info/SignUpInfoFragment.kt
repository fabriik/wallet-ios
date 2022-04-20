package com.fabriik.signup.ui.signup.info

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.lifecycleScope
import androidx.navigation.fragment.findNavController
import com.fabriik.signup.R
import com.fabriik.signup.databinding.FragmentSignUpInfoBinding
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.clickableSpan
import kotlinx.coroutines.launch

class SignUpInfoFragment : Fragment(), FabriikView<SignUpInfoViewState, SignUpInfoViewEffect> {

    private lateinit var binding: FragmentSignUpInfoBinding
    private val viewModel: SignUpInfoViewModel by lazy {
        ViewModelProvider(this).get(SignUpInfoViewModel::class.java)
    }

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?
    ): View {
        return inflater.inflate(R.layout.fragment_sign_up_info, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        binding = FragmentSignUpInfoBinding.bind(view)

        binding.btnSubmit.setOnClickListener {
            lifecycleScope.launch {
                viewModel.actions.send(
                    SignUpInfoViewAction.SubmitClicked(
                        email = binding.etEmail.text.toString(),
                        phone = binding.etPhone.text.toString(),
                        password = binding.etPassword.text.toString(),
                        lastName = binding.etLastName.text.toString(),
                        firstName = binding.etFirstName.text.toString(),
                    )
                )
            }
        }

        binding.tvTerms.clickableSpan(
            fullTextRes = R.string.SignUp_Terms,
            clickableParts = mapOf(
                R.string.SignUp_Terms_Link1 to {
                    lifecycleScope.launch {
                        viewModel.actions.send(
                            SignUpInfoViewAction.UserAgreementClicked
                        )
                    }
                },
                R.string.SignUp_Terms_Link2 to {
                    lifecycleScope.launch {
                        viewModel.actions.send(
                            SignUpInfoViewAction.PrivacyPolicyClicked
                        )
                    }
                }
            )
        )

        viewModel.state.observe(viewLifecycleOwner) {
            render(it)
        }

        viewModel.effect.observe(viewLifecycleOwner) {
            handleEffect(it)
        }
    }

    override fun render(state: SignUpInfoViewState) {
        with(state) {
            //todo: loading
        }
    }

    override fun handleEffect(effect: SignUpInfoViewEffect?) {
        when (effect) {
            is SignUpInfoViewEffect.GoToConfirmation -> {
                findNavController().navigate(
                    SignUpInfoFragmentDirections.actionConfirmEmail(
                        effect.sessionKey
                    )
                )
            }
            is SignUpInfoViewEffect.OpenWebsite -> {
                //todo
            }
        }
    }
}