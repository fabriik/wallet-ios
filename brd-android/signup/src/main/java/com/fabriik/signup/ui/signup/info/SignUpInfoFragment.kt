package com.fabriik.signup.ui.signup.info

import android.content.ActivityNotFoundException
import android.content.Intent
import android.net.Uri
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
import com.fabriik.signup.ui.SignupActivity
import com.fabriik.signup.ui.base.FabriikView
import com.fabriik.signup.utils.SnackBarUtils
import com.fabriik.signup.utils.clickableSpan
import com.fabriik.signup.utils.hideKeyboard
import com.fabriik.signup.utils.setValidator
import com.fabriik.signup.utils.validators.EmailValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import com.fabriik.signup.utils.validators.PhoneNumberValidator
import com.fabriik.signup.utils.validators.TextValidator
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.launch

class SignUpInfoFragment : Fragment(), FabriikView<SignUpInfoContract.State, SignUpInfoContract.Effect> {

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

        with(binding) {

            // setup input fields
            etEmail.setValidator(EmailValidator)
            etPhone.setValidator(PhoneNumberValidator)
            etPassword.setValidator(PasswordValidator)
            etLastName.setValidator(TextValidator)
            etFirstName.setValidator(TextValidator)

            // setup "Submit" button
            btnSubmit.setOnClickListener {
                hideKeyboard()

                viewModel.setEvent(
                    SignUpInfoContract.Event.SubmitClicked(
                        email = binding.etEmail.text.toString(),
                        phone = binding.etPhone.text.toString(),
                        password = binding.etPassword.text.toString(),
                        lastName = binding.etLastName.text.toString(),
                        firstName = binding.etFirstName.text.toString(),
                        termsAccepted = binding.cbTerms.isChecked
                    )
                )
            }

            // setup "T&C / Privacy Policy" checkbox
            tvTerms.clickableSpan(
                fullTextRes = R.string.SignUp_Terms,
                clickableParts = mapOf(
                    R.string.SignUp_Terms_Link1 to {
                        viewModel.setEvent(
                            SignUpInfoContract.Event.UserAgreementClicked
                        )
                    },
                    R.string.SignUp_Terms_Link2 to {
                        viewModel.setEvent(
                            SignUpInfoContract.Event.PrivacyPolicyClicked
                        )
                    }
                )
            )
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

    override fun render(state: SignUpInfoContract.State) {
        //empty
    }

    override fun handleEffect(effect: SignUpInfoContract.Effect) {
        when (effect) {
            is SignUpInfoContract.Effect.GoToConfirmation -> {
                findNavController().navigate(
                    SignUpInfoFragmentDirections.actionConfirmEmail(
                        effect.sessionKey
                    )
                )
            }
            is SignUpInfoContract.Effect.OpenWebsite -> {
                try {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(effect.url))
                    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    startActivity(intent)
                } catch (ex: ActivityNotFoundException) {
                    SnackBarUtils.showLong(
                        view = binding.root,
                        text = R.string.SignUp_BrowserNotInstalled
                    )
                }
            }
            is SignUpInfoContract.Effect.ShowLoading -> {
                val activity = activity as SignupActivity?
                activity?.showLoading(effect.show)
            }
            is SignUpInfoContract.Effect.ShowSnackBar -> {
                SnackBarUtils.showLong(
                    view = binding.root,
                    text = effect.message
                )
            }
        }
    }
}