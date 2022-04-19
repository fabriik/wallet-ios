package com.fabriik.signup.ui.signup

import com.fabriik.signup.ui.base.FabriikViewState

data class SignUpViewState(
    private val isLoading: Boolean = false,
    private val errorMessage: String? = null
) : FabriikViewState