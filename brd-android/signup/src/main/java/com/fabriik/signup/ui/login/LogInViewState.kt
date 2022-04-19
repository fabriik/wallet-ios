package com.fabriik.signup.ui.login

import com.fabriik.signup.ui.base.FabriikViewState

data class LogInViewState(
    private val isLoading: Boolean = false,
    private val errorMessage: String? = null
) : FabriikViewState