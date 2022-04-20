package com.fabriik.signup.ui.base

internal interface FabriikView<S: FabriikUiState, E: FabriikUiEffect?> {
    fun render(state: S)
    fun handleEffect(effect: E?)
}