package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.Resource
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
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

    private val userApi = UserApi.create()

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
        viewModelScope.launch(Dispatchers.IO) {
            try {
                updateState {
                    it.copy(isLoading = true)
                }

                val response = userApi.login(
                    username = email,
                    password = password
                )

                when (response.status) {
                    Status.SUCCESS -> {
                        updateState {
                            it.copy(
                                isLoading = false
                            )
                        }

                        _effect.postValue(
                            LogInViewEffect.ShowToast(
                                "Login successfully completed"
                            )
                        )
                    }
                    else -> {
                        updateState {
                            it.copy(
                                isLoading = false,
                                errorMessage = response.message
                            )
                        }
                    }
                }
            } catch (e: Exception) {
                updateState {
                    it.copy(
                        isLoading = false,
                        errorMessage = e.message
                    )
                }
            }
        }
    }

    private suspend fun updateState(handler: suspend (intent: LogInViewState) -> LogInViewState) {
        _state.postValue(handler(state.value!!))
    }
}