package com.fabriik.signup.ui.base

internal interface FabriikView<State: FabriikContract.State, Effect: FabriikContract.Effect> {
    fun render(state: State)
    fun handleEffect(effect: Effect)
}