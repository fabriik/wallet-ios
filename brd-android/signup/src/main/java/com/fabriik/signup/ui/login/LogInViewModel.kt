package com.fabriik.signup.ui.login

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.SavedStateHandle
import com.fabriik.signup.ui.base.FabriikViewModel

class LogInViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<LogInViewState, LogInViewAction, LogInViewEffect> {
}