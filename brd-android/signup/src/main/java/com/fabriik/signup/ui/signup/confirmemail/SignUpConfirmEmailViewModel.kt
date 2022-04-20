package com.fabriik.signup.ui.signup.confirmemail

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
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
    FabriikViewModel<SignUpConfirmEmailContract.State, SignUpConfirmEmailContract.Event, SignUpConfirmEmailContract.Effect> {

    private val _event: MutableSharedFlow<SignUpConfirmEmailContract.Event> = MutableSharedFlow()
    override val event = _event.asSharedFlow()

    private val _state = MutableStateFlow(SignUpConfirmEmailContract.State())
    override val state = _state.asStateFlow()

    private val _effect = Channel<SignUpConfirmEmailContract.Effect>()
    override val effect = _effect.receiveAsFlow()

    private val arguments = SignUpConfirmEmailFragmentArgs.fromBundle(
        savedStateHandle.toBundle()
    )

    private val userApi = UserApi.create(application.applicationContext)

    init {
        subscribeEvents()
    }

    fun setEvent(event: SignUpConfirmEmailContract.Event) {
        viewModelScope.launch {
            _event.emit(event)
        }
    }

    private fun subscribeEvents() {
        viewModelScope.launch {
            event.collect {
                when (it) {
                    is SignUpConfirmEmailContract.Event.ConfirmClicked -> {
                        confirmRegistration(it.confirmationCode)
                    }
                    is SignUpConfirmEmailContract.Event.ResendCodeClicked -> {

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
                    SignUpConfirmEmailContract.Effect.ShowSnackBar(
                        getString(R.string.ConfirmEmail_EnterValidData)
                    )
                )
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            _effect.send(
                SignUpConfirmEmailContract.Effect.ShowLoading(true)
            )

            val response = userApi.confirmRegistration(
                sessionKey = arguments.sessionKey,
                confirmationCode = confirmationCode
            )

            _effect.send(
                SignUpConfirmEmailContract.Effect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.send(
                        SignUpConfirmEmailContract.Effect.ShowSnackBar(
                            getString(R.string.SignUp_Completed)
                        )
                    )

                    _effect.send(
                        SignUpConfirmEmailContract.Effect.GoToLogin
                    )
                }
                else -> {
                    _effect.send(
                        SignUpConfirmEmailContract.Effect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }
}