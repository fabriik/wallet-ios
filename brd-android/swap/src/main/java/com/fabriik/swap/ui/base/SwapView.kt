package com.fabriik.swap.ui.base

internal interface SwapView<S: SwapState, E: SwapEffect?> {
    fun render(state: S)
    fun handleEffect(effect: E?)
}