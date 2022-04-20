package com.fabriik.signup.ui.forgotpassword.enteremail

import android.app.Application
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel

class ForgotPasswordEnterEmailViewModel(
    application: Application
) : FabriikViewModel<ForgotPasswordEnterEmailContract.State, ForgotPasswordEnterEmailContract.Event, ForgotPasswordEnterEmailContract.Effect>(application) {

    private val userApi = UserApi.create(application.applicationContext)

    override fun createInitialState() = ForgotPasswordEnterEmailContract.State()

    override fun handleEvent(event: ForgotPasswordEnterEmailContract.Event) {
        when (event) {
            is ForgotPasswordEnterEmailContract.Event.ConfirmClicked -> {
                // todo
            }
        }
    }
}