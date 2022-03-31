package com.fabriik.swap.ui.base

import androidx.lifecycle.LiveData
import kotlinx.coroutines.channels.Channel

internal interface SwapViewModel<S: SwapState, A: SwapAction, E: SwapEffect?> {
    val actions: Channel<A>
    val state: LiveData<S>
    val effect: LiveData<E?>
}