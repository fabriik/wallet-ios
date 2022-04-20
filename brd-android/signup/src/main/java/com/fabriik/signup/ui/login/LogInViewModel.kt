package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.validators.EmailValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

class LogInViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    FabriikViewModel<LogInViewState, LogInViewAction, LogInViewEffect> {

    override val actions: Channel<LogInViewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<LogInViewState>
        get() = _state

    override val effect: LiveData<LogInViewEffect?>
        get() = _effect

    private val _state = MutableLiveData<LogInViewState>().apply {
        value = LogInViewState()
    }
    private val _effect = SingleLiveEvent<LogInViewEffect?>()

    private val userApi = UserApi.create(application.applicationContext)

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is LogInViewAction.SubmitClicked -> login(
                        email = it.email,
                        password = it.password
                    )
                    is LogInViewAction.SignUpClicked -> {
                        _effect.postValue(
                            LogInViewEffect.GoToSignUp
                        )
                    }
                    is LogInViewAction.ForgotPasswordClicked -> {
                        _effect.postValue(
                            LogInViewEffect.GoToForgotPassword
                        )
                    }
                }
            }
        }
    }

    private fun login(email: String, password: String) {
        // validate input data
        val emailValidation = EmailValidator(email)
        val passwordValidation = PasswordValidator(password)

        if (!emailValidation || !passwordValidation) {
            _effect.postValue(
                LogInViewEffect.ShowSnackBar(
                    getString(R.string.LogIn_EnterValidData)
                )
            )
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            updateState {
                it.copy(isLoading = true)
            }

            val response = userApi.login(
                username = email,
                password = password
            )

            updateState {
                it.copy(isLoading = false)
            }

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.postValue(
                        LogInViewEffect.ShowSnackBar(
                            getString(R.string.LogIn_Completed)
                        )
                    )
                }
                else -> {
                    _effect.postValue(
                        LogInViewEffect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }

    private suspend fun updateState(handler: suspend (intent: LogInViewState) -> LogInViewState) {
        _state.postValue(handler(state.value!!))
    }
}