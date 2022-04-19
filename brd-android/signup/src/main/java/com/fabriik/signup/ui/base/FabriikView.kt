package com.fabriik.signup.ui.base

internal interface FabriikView<S: FabriikViewState, E: FabriikViewEffect?> {
    fun render(state: S)
    fun handleEffect(effect: E?)
}