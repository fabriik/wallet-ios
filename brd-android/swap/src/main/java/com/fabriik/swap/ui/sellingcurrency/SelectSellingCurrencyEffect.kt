package com.fabriik.swap.ui.sellingcurrency

import com.fabriik.swap.data.responses.SwapCurrency

sealed class SelectSellingCurrencyEffect {
    object CloseScreen : SelectSellingCurrencyEffect()
    class NavigateToBuyingCurrencies(val sellingCurrency: SwapCurrency) : SelectSellingCurrencyEffect()
}