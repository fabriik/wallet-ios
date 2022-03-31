package com.fabriik.swap.ui.sellingcurrency

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapEffect

sealed class SelectSellingCurrencyEffect : SwapEffect {
    object GoToHome : SelectSellingCurrencyEffect()
    class GoToBuyingCurrencySelection(val sellingCurrency: SwapCurrency) : SelectSellingCurrencyEffect()
}