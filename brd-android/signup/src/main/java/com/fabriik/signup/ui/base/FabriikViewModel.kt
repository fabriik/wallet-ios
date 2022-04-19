package com.fabriik.signup.ui.base

import androidx.lifecycle.LiveData
import kotlinx.coroutines.channels.Channel

internal interface FabriikViewModel<S : FabriikViewState, A : FabriikViewAction, E : FabriikViewEffect?> {
    val actions: Channel<A>
    val state: LiveData<S>
    val effect: LiveData<E?>
}