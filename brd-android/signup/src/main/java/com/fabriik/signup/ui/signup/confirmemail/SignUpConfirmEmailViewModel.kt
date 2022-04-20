package com.fabriik.signup.ui.signup.confirmemail

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.utils.SingleLiveEvent
import com.fabriik.signup.utils.toBundle
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

class SignUpConfirmEmailViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<SignUpConfirmEmailViewState, SignUpConfirmEmailViewAction, SignUpConfirmEmailViewEffect> {

    override val actions: Channel<SignUpConfirmEmailViewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SignUpConfirmEmailViewState>
        get() = _state

    override val effect: LiveData<SignUpConfirmEmailViewEffect?>
        get() = _effect

    private val _state = MutableLiveData<SignUpConfirmEmailViewState>().apply {
        value = SignUpConfirmEmailViewState()
    }
    private val _effect = SingleLiveEvent<SignUpConfirmEmailViewEffect?>()

    private val arguments = SignUpConfirmEmailFragmentArgs.fromBundle(
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
                    is SignUpConfirmEmailViewAction.ConfirmClicked -> {
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
                            SignUpConfirmEmailViewEffect.FinishWithToastMessage(
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

    private suspend fun updateState(handler: suspend (intent: SignUpConfirmEmailViewState) -> SignUpConfirmEmailViewState) {
        _state.postValue(handler(state.value!!))
    }
}