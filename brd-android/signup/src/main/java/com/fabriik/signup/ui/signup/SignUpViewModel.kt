package com.fabriik.signup.ui.signup

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.SavedStateHandle
import com.fabriik.signup.ui.base.FabriikViewModel

class SignUpViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<SignUpViewState, SignUpViewAction, SignUpViewEffect> {
}