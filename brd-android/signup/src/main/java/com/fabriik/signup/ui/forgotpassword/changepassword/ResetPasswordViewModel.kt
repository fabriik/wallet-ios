package com.fabriik.signup.ui.forgotpassword.changepassword

import android.app.Application
import com.fabriik.signup.data.UserApi
import com.fabriik.signup.ui.base.FabriikViewModel

class ResetPasswordViewModel(
    application: Application
) : FabriikViewModel<ResetPasswordContract.State, ResetPasswordContract.Event, ResetPasswordContract.Effect>(application) {

    private val userApi = UserApi.create(application.applicationContext)

    override fun createInitialState() = ResetPasswordContract.State()

    override fun handleEvent(event: ResetPasswordContract.Event) {
        when (event) {
            is ResetPasswordContract.Event.ConfirmClicked -> {
                // todo: API call

                setEffect {
                    ResetPasswordContract.Effect.GoToResetCompleted
                }
            }
        }
    }
}