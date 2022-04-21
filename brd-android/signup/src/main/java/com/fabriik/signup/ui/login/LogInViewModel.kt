package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.validators.EmailValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class LogInViewModel(
    application: Application
) : FabriikViewModel<LogInContract.State, LogInContract.Event, LogInContract.Effect>(application) {

    private val userApi = UserApi.create(application.applicationContext)

    override fun createInitialState() = LogInContract.State()

    override fun handleEvent(event: LogInContract.Event) {
        when (event) {
            is LogInContract.Event.SubmitClicked -> login(
                email = event.email,
                password = event.password
            )
            is LogInContract.Event.SignUpClicked -> {
                setEffect {
                    LogInContract.Effect.GoToSignUp
                }
            }
            is LogInContract.Event.ForgotPasswordClicked -> {
                setEffect {
                    LogInContract.Effect.GoToForgotPassword
                }
            }
        }
    }

    private fun login(email: String, password: String) {
        // validate input data
        val emailValidation = EmailValidator(email)
        val passwordValidation = PasswordValidator(password)

        if (!emailValidation || !passwordValidation) {
            setEffect {
                LogInContract.Effect.ShowSnackBar(
                    getString(R.string.LogIn_EnterValidData)
                )
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            setEffect {
                LogInContract.Effect.ShowLoading(true)
            }

            val response = userApi.login(
                username = email,
                password = password
            )

            setEffect {
                LogInContract.Effect.ShowLoading(false)
            }

            when (response.status) {
                Status.SUCCESS -> {
                    setEffect {
                        LogInContract.Effect.ShowSnackBar(
                            getString(R.string.LogIn_Completed)
                        )
                    }
                }
                else -> {
                    setEffect {
                        LogInContract.Effect.ShowSnackBar(
                            response.message ?: getString(R.string.SignUp_DefaultErrorMessage)
                        )
                    }
                }
            }
        }
    }
}