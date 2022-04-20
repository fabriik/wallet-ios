package com.fabriik.signup.ui.signup.confirmemail

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.ui.login.LogInUiEvent
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.toBundle
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class SignUpConfirmEmailViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    FabriikViewModel<SignUpConfirmEmailUiState, SignUpConfirmEmailUiEvent, SignUpConfirmEmailUiEffect> {

    private val _event: MutableSharedFlow<SignUpConfirmEmailUiEvent> = MutableSharedFlow()
    override val event = _event.asSharedFlow()

    private val _state = MutableStateFlow(SignUpConfirmEmailUiState())
    override val state = _state.asStateFlow()

    private val _effect = Channel<SignUpConfirmEmailUiEffect>()
    override val effect = _effect.receiveAsFlow()

    private val arguments = SignUpConfirmEmailFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val userApi = UserApi.create(application.applicationContext)

    init {
        subscribeEvents()
    }

    fun setEvent(event: SignUpConfirmEmailUiEvent) {
        viewModelScope.launch {
            _event.emit(event)
        }
    }

    private fun subscribeEvents() {
        viewModelScope.launch {
            event.collect {
                when (it) {
                    is SignUpConfirmEmailUiEvent.ConfirmClicked -> {
                        confirmRegistration(it.confirmationCode)
                    }
                    is SignUpConfirmEmailUiEvent.ResendCodeClicked -> {

                    }
                }
            }
        }
    }

    private fun confirmRegistration(confirmationCode: String) {
        // validate input data
        if (!ConfirmationCodeValidator(confirmationCode)) {
            viewModelScope.launch {
                _effect.send(
                    SignUpConfirmEmailUiEffect.ShowSnackBar(
                        getString(R.string.ConfirmEmail_EnterValidData)
                    )
                )
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            _effect.send(
                SignUpConfirmEmailUiEffect.ShowLoading(true)
            )

            val response = userApi.confirmRegistration(
                sessionKey = arguments.sessionKey,
                confirmationCode = confirmationCode
            )

            _effect.send(
                SignUpConfirmEmailUiEffect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.send(
                        SignUpConfirmEmailUiEffect.ShowSnackBar(
                            getString(R.string.SignUp_Completed)
                        )
                    )

                    _effect.send(
                        SignUpConfirmEmailUiEffect.GoToLogin
                    )
                }
                else -> {
                    _effect.send(
                        SignUpConfirmEmailUiEffect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }
}