package com.fabriik.signup.ui.signup.info

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.FabriikApiConstants
import com.fabriik.signup.data.Status
import com.fabriik.signup.R
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.validators.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class SignUpInfoViewModel(
    application: Application
) : FabriikViewModel<SignUpInfoContract.State, SignUpInfoContract.Event, SignUpInfoContract.Effect>(
    application
) {

    private val userApi = UserApi.create(application.applicationContext)

    init {
        subscribeEvents()
    }

    override fun createInitialState() = SignUpInfoContract.State()

    private fun subscribeEvents() {
        viewModelScope.launch {
            event.collect {
                when (it) {
                    is SignUpInfoContract.Event.SubmitClicked -> {
                        register(
                            email = it.email,
                            phone = it.phone,
                            password = it.password,
                            lastName = it.lastName,
                            firstName = it.firstName,
                            termsAccepted = it.termsAccepted
                        )
                    }
                    is SignUpInfoContract.Event.PrivacyPolicyClicked -> {
                        setEffect {
                            SignUpInfoContract.Effect.OpenWebsite(
                                FabriikApiConstants.URL_PRIVACY_POLICY
                            )
                        }
                    }
                    is SignUpInfoContract.Event.UserAgreementClicked -> {
                        setEffect {
                            SignUpInfoContract.Effect.OpenWebsite(
                                FabriikApiConstants.URL_TERMS_AND_CONDITIONS
                            )
                        }
                    }
                }
            }
        }
    }

    private fun register(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        phone: String,
        termsAccepted: Boolean
    ) {
        // validate input data
        val emailValidation = EmailValidator(email)
        val phoneValidation = PhoneNumberValidator(phone)
        val passwordValidation = PasswordValidator(password)
        val firstNameValidation = TextValidator(firstName)
        val lastNameValidation = TextValidator(lastName)

        if (!emailValidation || !phoneValidation || !passwordValidation || !firstNameValidation || !lastNameValidation || !termsAccepted) {
            setEffect {
                SignUpInfoContract.Effect.ShowSnackBar(
                    getString(R.string.SignUp_EnterValidData)
                )
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            setEffect {
                SignUpInfoContract.Effect.ShowLoading(true)
            }

            val response = userApi.register(
                email = email,
                phone = phone,
                password = password,
                lastName = lastName,
                firstName = firstName
            )

            setEffect {
                SignUpInfoContract.Effect.ShowLoading(false)
            }

            when (response.status) {
                Status.SUCCESS -> {
                    setEffect {
                        SignUpInfoContract.Effect.GoToConfirmation(
                            response.data!!.sessionKey
                        )
                    }
                }
                else -> {
                    setEffect {
                        SignUpInfoContract.Effect.ShowSnackBar(
                            response.message!!
                        )
                    }
                }
            }
        }
    }
}