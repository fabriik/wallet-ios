package com.fabriik.swap.ui.buyingCurrency

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapEffect
import java.math.BigDecimal

sealed class SelectBuyingCurrencyEffect : SwapEffect {
    object GoToHome : SelectBuyingCurrencyEffect()
    object GoBack : SelectBuyingCurrencyEffect()
    class GoToAmountSelection(val exchangeRate: BigDecimal, val sellingCurrency: SwapCurrency, val buyingCurrency: SwapCurrency) :
        SelectBuyingCurrencyEffect()
}