package com.fabriik.signup.ui.signup.info

import android.app.Application
import androidx.lifecycle.*
import com.fabriik.signup.data.FabriikApiConstants
import com.fabriik.signup.data.Status
import com.fabriik.signup.R
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel
import com.fabriik.signup.ui.signup.confirmemail.SignUpConfirmEmailViewEffect
import com.fabriik.signup.utils.SingleLiveEvent
import com.fabriik.signup.utils.getString
import com.fabriik.signup.utils.validators.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.flow.collect
import kotlinx.coroutines.flow.consumeAsFlow
import kotlinx.coroutines.launch

class SignUpInfoViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application),
    FabriikViewModel<SignUpInfoViewState, SignUpInfoViewAction, SignUpInfoViewEffect>,
    LifecycleObserver {

    override val actions: Channel<SignUpInfoViewAction> = Channel(Channel.UNLIMITED)

    override val state: LiveData<SignUpInfoViewState>
        get() = _state

    override val effect: LiveData<SignUpInfoViewEffect?>
        get() = _effect

    private val _state = MutableLiveData<SignUpInfoViewState>().apply {
        value = SignUpInfoViewState()
    }
    private val _effect = SingleLiveEvent<SignUpInfoViewEffect?>()

    private val userApi = UserApi.create(application.applicationContext)

    init {
        handleAction()
    }

    private fun handleAction() {
        viewModelScope.launch {
            actions.consumeAsFlow().collect {
                when (it) {
                    is SignUpInfoViewAction.SubmitClicked -> {
                        register(
                            email = it.email,
                            phone = it.phone,
                            password = it.password,
                            lastName = it.lastName,
                            firstName = it.firstName,
                            termsAccepted = it.termsAccepted
                        )
                    }
                    is SignUpInfoViewAction.PrivacyPolicyClicked -> {
                        _effect.postValue(
                            SignUpInfoViewEffect.OpenWebsite(
                                FabriikApiConstants.URL_PRIVACY_POLICY
                            )
                        )
                    }
                    is SignUpInfoViewAction.UserAgreementClicked -> {
                        _effect.postValue(
                            SignUpInfoViewEffect.OpenWebsite(
                                FabriikApiConstants.URL_TERMS_AND_CONDITIONS
                            )
                        )
                    }
                }
            }
        }
    }

    private fun register(
        email: String, password: String, firstName: String, lastName: String, phone: String, termsAccepted: Boolean
    ) {
        // validate input data
        val emailValidation = EmailValidator(email)
        val phoneValidation = PhoneNumberValidator(phone)
        val passwordValidation = PasswordValidator(password)
        val firstNameValidation = TextValidator(firstName)
        val lastNameValidation = TextValidator(lastName)

        if (!emailValidation || !phoneValidation || !passwordValidation || !firstNameValidation || !lastNameValidation || !termsAccepted) {
            _effect.postValue(
                SignUpInfoViewEffect.ShowSnackBar(
                    getString(R.string.SignUp_EnterValidData)
                )
            )
            return
        }

        // execute API call
        viewModelScope.launch(Dispatchers.IO) {
            _effect.postValue(
                SignUpInfoViewEffect.ShowLoading(true)
            )

            val response = userApi.register(
                email = email,
                phone = phone,
                password = password,
                lastName = lastName,
                firstName = firstName
            )

            _effect.postValue(
                SignUpInfoViewEffect.ShowLoading(false)
            )

            when (response.status) {
                Status.SUCCESS -> {
                    _effect.postValue(
                        SignUpInfoViewEffect.GoToConfirmation(
                            response.data!!.sessionKey
                        )
                    )
                }
                else -> {
                    _effect.postValue(
                        SignUpInfoViewEffect.ShowSnackBar(
                            response.message!!
                        )
                    )
                }
            }
        }
    }

    private suspend fun updateState(handler: suspend (intent: SignUpInfoViewState) -> SignUpInfoViewState) {
        _state.postValue(handler(state.value!!))
    }
}