package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.SavedStateHandle
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
import kotlinx.coroutines.channels.Channel

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
        /*viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {

                }
            }
        }*/
    }
}