package com.fabriik.signup.ui.signup

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.ui.login.LogInViewEffect
import com.fabriik.signup.ui.login.LogInViewState
import com.fabriik.signup.utils.SingleLiveEvent
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
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

    private val userApi = UserApi.create()

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when(it) {
                    is SignUpViewAction.SubmitClicked -> {
                        register(
                            email = it.email,
                            phone = it.phone,
                            password = it.password,
                            lastName = it.lastName,
                            firstName = it.firstName,
                        )
                    }
                    is SignUpViewAction.PrivacyPolicyClicked -> {
                        _effect.postValue(
                            SignUpViewEffect.OpenWebsite("https://www.google.com")
                        )
                    }
                    is SignUpViewAction.UserAgreementClicked -> {
                        _effect.postValue(
                            SignUpViewEffect.OpenWebsite("https://www.google.com")
                        )
                    }
                }
            }
        }
    }

    private fun register(email: String, password: String, firstName: String, lastName: String, phone: String) {
        viewModelScope.launch(Dispatchers.IO) {
            try {
                updateState {
                    it.copy(isLoading = true)
                }

                val response = userApi.register(
                    email = email,
                    phone = phone,
                    password = password,
                    lastName = lastName,
                    firstName = firstName
                )

                when (response.status) {
                    Status.SUCCESS -> {
                        updateState {
                            it.copy(
                                isLoading = false
                            )
                        }

                        _effect.postValue(
                            SignUpViewEffect.GoToConfirmation(
                                response.data!!.sessionKey
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

    private suspend fun updateState(handler: suspend (intent: SignUpViewState) -> SignUpViewState) {
        _state.postValue(handler(state.value!!))
    }
}