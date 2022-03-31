package com.fabriik.swap.ui.buyingCurrency

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapEffect

sealed class SelectBuyingCurrencyEffect : SwapEffect {
    object GoToHome : SelectBuyingCurrencyEffect()
    object GoBack : SelectBuyingCurrencyEffect()
    class GoToAmountSelection(val sellingCurrency: SwapCurrency, val buyingCurrency: SwapCurrency) :
        SelectBuyingCurrencyEffect()
}