package com.fabriik.signup.ui.confirmemail

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.ui.signup.SignUpViewEffect
import com.fabriik.signup.ui.signup.SignUpViewState
import com.fabriik.signup.utils.SingleLiveEvent
import com.fabriik.signup.utils.toBundle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

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

    private val arguments = ConfirmEmailFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val userApi = UserApi.create()

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when(it) {
                    is ConfirmEmailViewAction.ConfirmClicked -> {
                        confirmRegistration(it.confirmationCode)
                    }
                }
            }
        }
    }

    private fun confirmRegistration(confirmationCode: String) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                updateState {
                    it.copy(isLoading = true)
                }

                val response = userApi.confirmRegistration(
                    sessionKey = arguments.sessionKey,
                    confirmationCode = confirmationCode
                )

                when (response.status) {
                    Status.SUCCESS -> {
                        updateState {
                            it.copy(
                                isLoading = false
                            )
                        }

                        _effect.postValue(
                            ConfirmEmailViewEffect.FinishWithToastMessage(
                                "Registration successfully completed!!"
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

    private suspend fun updateState(handler: suspend (intent: ConfirmEmailViewState) -> ConfirmEmailViewState) {
        _state.postValue(handler(state.value!!))
    }
}