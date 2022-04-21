package com.fabriik.signup.ui.forgotpassword.enteremail

import android.app.Application
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel

class ForgotPasswordViewModel(
    application: Application
) : FabriikViewModel<ForgotPasswordContract.State, ForgotPasswordContract.Event, ForgotPasswordContract.Effect>(application) {

    private val userApi = UserApi.create(application.applicationContext)

    override fun createInitialState() = ForgotPasswordContract.State()

    override fun handleEvent(event: ForgotPasswordContract.Event) {
        when (event) {
            is ForgotPasswordContract.Event.ConfirmClicked -> {
                // todo: API call
                setEffect {
                    ForgotPasswordContract.Effect.GoToResetPassword
                }
            }
        }
    }
}