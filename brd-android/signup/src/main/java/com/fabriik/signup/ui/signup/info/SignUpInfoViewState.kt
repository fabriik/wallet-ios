package com.fabriik.signup.ui.signup.info

import com.fabriik.signup.ui.base.FabriikViewState

data class SignUpInfoViewState(
    private val isLoading: Boolean = false,
    private val errorMessage: String? = null
) : FabriikViewState