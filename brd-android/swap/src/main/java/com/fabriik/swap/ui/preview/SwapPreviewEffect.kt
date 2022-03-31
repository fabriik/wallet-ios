package com.fabriik.swap.ui.preview

import com.fabriik.swap.ui.base.SwapEffect

sealed class SwapPreviewEffect : SwapEffect {
    object GoToHome : SwapPreviewEffect()
    object GoBack : SwapPreviewEffect()
}