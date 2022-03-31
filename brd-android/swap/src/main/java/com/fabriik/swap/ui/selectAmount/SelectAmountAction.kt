package com.fabriik.swap.ui.selectAmount

import com.fabriik.swap.ui.base.SwapAction
import java.math.BigDecimal

sealed class SelectAmountAction : SwapAction {
    object Back : SelectAmountAction()
    object Close : SelectAmountAction()
    object ConfirmClicked : SelectAmountAction()
    class AmountChanged(val amount: BigDecimal) : SelectAmountAction()
}