package com.fabriik.signup.ui.signup

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

class SignUpViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<SignUpViewState, SignUpViewAction, SignUpViewEffect>,
    LifecycleObserver {

    override val actions: Channel<SignUpViewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SignUpViewState>
        get() = _state

    override val effect: LiveData<SignUpViewEffect?>
        get() = _effect

    private val _state = MutableLiveData<SignUpViewState>().apply {
        value = SignUpViewState()
    }
    private val _effect = SingleLiveEvent<SignUpViewEffect?>()

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