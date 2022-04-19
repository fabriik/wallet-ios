package com.fabriik.signup.ui.confirmemail

import android.app.Application
import androidx.lifecycle.AndroidViewModel
import androidx.lifecycle.SavedStateHandle
import com.fabriik.signup.ui.base.FabriikViewModel

class ConfirmEmailViewModel(
    application: Application,
    savedStateHandle: SavedStateHandle
) : AndroidViewModel(application), FabriikViewModel<ConfirmEmailViewState, ConfirmEmailViewAction, ConfirmEmailViewEffect> {
}