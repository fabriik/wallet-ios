package com.fabriik.signup.ui.confirmemail

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.SavedStateHandle
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
import kotlinx.coroutines.channels.Channel

class ConfirmEmailViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<ConfirmEmailViewState, ConfirmEmailViewAction, ConfirmEmailViewEffect> {

    override val actions: Channel<ConfirmEmailViewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<ConfirmEmailViewState>
        get() = _state

    override val effect: LiveData<ConfirmEmailViewEffect?>
        get() = _effect

    private val _state = MutableLiveData<ConfirmEmailViewState>().apply {
        value = ConfirmEmailViewState()
    }
    private val _effect = SingleLiveEvent<ConfirmEmailViewEffect?>()

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