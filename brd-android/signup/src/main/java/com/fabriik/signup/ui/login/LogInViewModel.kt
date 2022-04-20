package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.getString
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class LogInViewModel(
    application: Application
) : AndroidViewModel(application),
    FabriikViewModel<LogInContract.State, LogInContract.Event, LogInContract.Effect> {

    private val _event: MutableSharedFlow<LogInContract.Event> = MutableSharedFlow()
    override val event = _event.asSharedFlow()

    private val _state = MutableStateFlow(LogInContract.State())
    override val state = _state.asStateFlow()

    private val _effect = Channel<LogInContract.Effect>()
    override val effect = _effect.receiveAsFlow()

    private val userApi = UserApi.create(application.applicationContext)

    init {
        subscribeEvents()
    }

    fun setEvent(event: LogInContract.Event) {
        viewModelScope.launch {
            _event.emit(event)
        }
    }

    private fun subscribeEvents() {
        viewModelScope.launch {
            event.collect {
                when (it) {
                    is LogInContract.Event.SubmitClicked -> login(
                        email = it.email,
                        password = it.password
                    )
                    is LogInContract.Event.SignUpClicked -> {
                        viewModelScope.launch {
                            _effect.send(LogInContract.Effect.GoToSignUp)
                        }
                    }
                    is LogInContract.Event.ForgotPasswordClicked -> {
                        viewModelScope.launch {
                            _effect.send(LogInContract.Effect.GoToForgotPassword)
                        }
                    }
                }
            }
        }
    }

    private fun login(email: String, password: String) {
        // validate input data
        /*val emailValidation = EmailValidator(email)
        val passwordValidation = PasswordValidator(password)

        if (!emailValidation || !passwordValidation) {
            _effect.postValue(
                LogInViewEffect.ShowSnackBar(
                    getString(R.string.LogIn_EnterValidData)
                )
            )
            return
        }*/

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            _effect.send(
                LogInContract.Effect.ShowLoading(true)
            )

            val response = userApi.login(
                username = email,
                password = password
            )

            _effect.send(
                LogInContract.Effect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.send(
                        LogInContract.Effect.ShowSnackBar(
                            getString(R.string.LogIn_Completed)
                        )
                    )
                }
                else -> {
                    _effect.send(
                        LogInContract.Effect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }
}