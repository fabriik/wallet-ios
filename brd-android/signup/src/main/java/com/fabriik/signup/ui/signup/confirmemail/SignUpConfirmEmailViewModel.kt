package com.fabriik.signup.ui.signup.confirmemail

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.toBundle
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class SignUpConfirmEmailViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : FabriikViewModel<SignUpConfirmEmailContract.State, SignUpConfirmEmailContract.Event, SignUpConfirmEmailContract.Effect>(application) {

    private val arguments = SignUpConfirmEmailFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val userApi = UserApi.create(application.applicationContext)

    override fun createInitialState() = SignUpConfirmEmailContract.State()

    override fun handleEvent(event: SignUpConfirmEmailContract.Event) {
        when (event) {
            is SignUpConfirmEmailContract.Event.ConfirmClicked -> {
                confirmRegistration(event.confirmationCode)
            }
            is SignUpConfirmEmailContract.Event.ResendCodeClicked -> {
                //todo
            }
        }
    }

    private fun confirmRegistration(confirmationCode: String) {
        // validate input data
        if (!ConfirmationCodeValidator(confirmationCode)) {
            viewModelScope.launch {
                setEffect {
                    SignUpConfirmEmailContract.Effect.ShowSnackBar(
                        getString(R.string.SignUpConfirm_EnterValidData)
                    )
                }
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            setEffect {
                SignUpConfirmEmailContract.Effect.ShowLoading(true)
            }

            val response = userApi.confirmRegistration(
                sessionKey = arguments.sessionKey,
                confirmationCode = confirmationCode
            )

            setEffect {
                SignUpConfirmEmailContract.Effect.ShowLoading(false)
            }

            when (response.status) {
                Status.SUCCESS -> {
                    setEffect {
                        SignUpConfirmEmailContract.Effect.ShowSnackBar(
                            getString(R.string.SignUp_Completed)
                        )
                    }

                    setEffect {
                        SignUpConfirmEmailContract.Effect.GoToLogin
                    }
                }
                else -> {
                    setEffect {
                        SignUpConfirmEmailContract.Effect.ShowSnackBar(
                            response.message ?: getString(R.string.SignUp_DefaultErrorMessage)
                        )
                    }
                }
            }
        }
    }
}