package com.fabriik.signup.ui.signup.info

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.FabriikApiConstants
import com.fabriik.signup.data.Status
import com.fabriik.signup.R
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.ui.login.LogInUiEvent
import com.fabriik.signup.ui.signup.confirmemail.SignUpConfirmEmailUiEvent
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.validators.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.*
import kotlinx.coroutines.launch

class SignUpInfoViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    FabriikViewModel<SignUpInfoUiState, SignUpInfoUiEvent, SignUpInfoUiEffect>,
    LifecycleObserver {

    private val _event: MutableSharedFlow<SignUpInfoUiEvent> = MutableSharedFlow()
    override val event = _event.asSharedFlow()

    private val _state = MutableStateFlow(SignUpInfoUiState())
    override val state = _state.asStateFlow()

    private val _effect = Channel<SignUpInfoUiEffect>()
    override val effect = _effect.receiveAsFlow()

    private val userApi = UserApi.create(application.applicationContext)

    init {
        subscribeEvents()
    }

    fun setEvent(event: SignUpInfoUiEvent) {
        viewModelScope.launch {
            _event.emit(event)
        }
    }

    private fun subscribeEvents() {
        viewModelScope.launch {
            event.collect {
                when (it) {
                    is SignUpInfoUiEvent.SubmitClicked -> {
                        register(
                            email = it.email,
                            phone = it.phone,
                            password = it.password,
                            lastName = it.lastName,
                            firstName = it.firstName,
                            termsAccepted = it.termsAccepted
                        )
                    }
                    is SignUpInfoUiEvent.PrivacyPolicyClicked -> {
                        _effect.send(
                            SignUpInfoUiEffect.OpenWebsite(
                                FabriikApiConstants.URL_PRIVACY_POLICY
                            )
                        )
                    }
                    is SignUpInfoUiEvent.UserAgreementClicked -> {
                        _effect.send(
                            SignUpInfoUiEffect.OpenWebsite(
                                FabriikApiConstants.URL_TERMS_AND_CONDITIONS
                            )
                        )
                    }
                }
            }
        }
    }

    private fun register(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        phone: String,
        termsAccepted: Boolean
    ) {
        // validate input data
        val emailValidation = EmailValidator(email)
        val phoneValidation = PhoneNumberValidator(phone)
        val passwordValidation = PasswordValidator(password)
        val firstNameValidation = TextValidator(firstName)
        val lastNameValidation = TextValidator(lastName)

        if (!emailValidation || !phoneValidation || !passwordValidation || !firstNameValidation || !lastNameValidation || !termsAccepted) {
            viewModelScope.launch {
                _effect.send(
                    SignUpInfoUiEffect.ShowSnackBar(
                        getString(R.string.SignUp_EnterValidData)
                    )
                )
            }
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            _effect.send(
                SignUpInfoUiEffect.ShowLoading(true)
            )

            val response = userApi.register(
                email = email,
                phone = phone,
                password = password,
                lastName = lastName,
                firstName = firstName
            )

            _effect.send(
                SignUpInfoUiEffect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.send(
                        SignUpInfoUiEffect.GoToConfirmation(
                            response.data!!.sessionKey
                        )
                    )
                }
                else -> {
                    _effect.send(
                        SignUpInfoUiEffect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }
}