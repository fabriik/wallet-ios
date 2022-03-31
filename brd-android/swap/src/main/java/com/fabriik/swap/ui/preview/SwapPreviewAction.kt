package com.fabriik.swap.ui.preview

import com.fabriik.swap.ui.base.SwapAction

sealed class SwapPreviewAction : SwapAction {
    object Back : SwapPreviewAction()
    object Close : SwapPreviewAction()
    object ConfirmClicked : SwapPreviewAction()
}