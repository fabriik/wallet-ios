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
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    FabriikViewModel<LogInUiState, LogInUiEvent, LogInUiEffect> {

    private val _event: MutableSharedFlow<LogInUiEvent> = MutableSharedFlow()
    override val event = _event.asSharedFlow()

    private val _state = MutableStateFlow(LogInUiState())
    override val state = _state.asStateFlow()

    private val _effect = Channel<LogInUiEffect>()
    override val effect = _effect.receiveAsFlow()

    private val userApi = UserApi.create(application.applicationContext)

    init {
        subscribeEvents()
    }

    fun setEvent(event: LogInUiEvent) {
        viewModelScope.launch {
            _event.emit(event)
        }
    }

    private fun subscribeEvents() {
        viewModelScope.launch {
            event.collect {
                when (it) {
                    is LogInUiEvent.SubmitClicked -> login(
                        email = it.email,
                        password = it.password
                    )
                    is LogInUiEvent.SignUpClicked -> {
                        viewModelScope.launch {
                            _effect.send(LogInUiEffect.GoToSignUp)
                        }
                    }
                    is LogInUiEvent.ForgotPasswordClicked -> {
                        viewModelScope.launch {
                            _effect.send(LogInUiEffect.GoToForgotPassword)
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
                LogInUiEffect.ShowLoading(true)
            )

            val response = userApi.login(
                username = email,
                password = password
            )

            _effect.send(
                LogInUiEffect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.send(
                        LogInUiEffect.ShowSnackBar(
                            getString(R.string.LogIn_Completed)
                        )
                    )
                }
                else -> {
                    _effect.send(
                        LogInUiEffect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }
}