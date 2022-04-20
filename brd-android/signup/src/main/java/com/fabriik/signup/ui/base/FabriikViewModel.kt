package com.fabriik.signup.ui.base

import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.SharedFlow
import kotlinx.coroutines.flow.StateFlow

internal interface FabriikViewModel<State : FabriikUiState, Event : FabriikUiEvent, Effect : FabriikUiEffect?> {
    val event: SharedFlow<Event>
    val state: StateFlow<State>
    val effect: Flow<Effect>
}