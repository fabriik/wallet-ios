package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

class LogInViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<LogInViewState, LogInViewAction, LogInViewEffect> {

    override val actions: Channel<LogInViewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<LogInViewState>
        get() = _state

    override val effect: LiveData<LogInViewEffect?>
        get() = _effect

    private val _state = MutableLiveData<LogInViewState>().apply {
        value = LogInViewState()
    }
    private val _effect = SingleLiveEvent<LogInViewEffect?>()

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is LogInViewAction.SubmitClicked -> login()
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

    private fun login() {

    }
}