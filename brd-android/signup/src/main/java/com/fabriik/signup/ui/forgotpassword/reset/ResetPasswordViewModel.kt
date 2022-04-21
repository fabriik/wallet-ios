package com.fabriik.signup.ui.forgotpassword.reset

import android.app.Application
import androidx.lifecycle.viewModelScope
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ResetPasswordViewModel(
    application: Application
) : FabriikViewModel<ResetPasswordContract.State, ResetPasswordContract.Event, ResetPasswordContract.Effect>(application) {

    private val userApi = UserApi.create(application.applicationContext)

    override fun createInitialState() = ResetPasswordContract.State()

    override fun handleEvent(event: ResetPasswordContract.Event) {
        when (event) {
            is ResetPasswordContract.Event.ConfirmClicked -> {
                resetPassword(
                    code = event.code,
                    password = event.password
                )
            }
        }
    }

    private fun resetPassword(code: String, password: String) {
        // validate input data
        val codeValidation = ConfirmationCodeValidator(code)
        val passwordValidation = PasswordValidator(password)

        if (!codeValidation || !passwordValidation) {
            viewModelScope.launch {
                setEffect {
                    ResetPasswordContract.Effect.ShowSnackBar(
                        getString(R.string.ResetPassword_EnterValidData)
                    )
                }
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            setEffect {
                ResetPasswordContract.Effect.ShowLoading(true)
            }

            val response = userApi.resetPassword(
                code = code,
                password = password
            )

            setEffect {
                ResetPasswordContract.Effect.ShowLoading(false)
            }

            when (response.status) {
                Status.SUCCESS -> {
                    setEffect {
                        ResetPasswordContract.Effect.GoToResetCompleted
                    }
                }
                else -> {
                    setEffect {
                        ResetPasswordContract.Effect.ShowSnackBar(
                            response.message ?: getString(R.string.SignUp_DefaultErrorMessage)
                        )
                    }
                }
            }
        }
    }
}