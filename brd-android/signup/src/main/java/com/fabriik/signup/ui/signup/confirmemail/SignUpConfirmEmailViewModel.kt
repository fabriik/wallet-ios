package com.fabriik.signup.ui.signup.confirmemail

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.R
import com.fabriik.signup.data.Status
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.ui.login.LogInViewEffect
import com.fabriik.signup.utils.SingleLiveEvent
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.toBundle
import com.fabriik.signup.utils.validators.ConfirmationCodeValidator
import com.fabriik.signup.utils.validators.EmailValidator
import com.fabriik.signup.utils.validators.PasswordValidator
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

class SignUpConfirmEmailViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    FabriikViewModel<SignUpConfirmEmailViewState, SignUpConfirmEmailViewAction, SignUpConfirmEmailViewEffect> {

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

    private val userApi = UserApi.create(application.applicationContext)

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is SignUpConfirmEmailViewAction.ConfirmClicked -> {
                        confirmRegistration(it.confirmationCode)
                    }
                }
            }
        }
    }

    private fun confirmRegistration(confirmationCode: String) {
        // validate input data
        if (!ConfirmationCodeValidator(confirmationCode)) {
            _effect.postValue(
                SignUpConfirmEmailViewEffect.ShowSnackBar(
                    getString(R.string.ConfirmEmail_EnterValidData)
                )
            )
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            _effect.postValue(
                SignUpConfirmEmailViewEffect.ShowLoading(true)
            )

            val response = userApi.confirmRegistration(
                sessionKey = arguments.sessionKey,
                confirmationCode = confirmationCode
            )

            _effect.postValue(
                SignUpConfirmEmailViewEffect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.postValue(
                        SignUpConfirmEmailViewEffect.ShowSnackBar(
                            getString(R.string.SignUp_Completed)
                        )
                    )

                    _effect.postValue(
                        SignUpConfirmEmailViewEffect.GoToLogin
                    )
                }
                else -> {
                    _effect.postValue(
                        SignUpConfirmEmailViewEffect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }

    private suspend fun updateState(handler: suspend (intent: SignUpConfirmEmailViewState) -> SignUpConfirmEmailViewState) {
        _state.postValue(handler(state.value!!))
    }
}