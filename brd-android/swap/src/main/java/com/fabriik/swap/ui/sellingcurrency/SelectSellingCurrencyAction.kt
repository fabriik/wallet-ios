package com.fabriik.swap.ui.sellingcurrency

import com.fabriik.swap.data.model.SellingCurrencyData
import com.fabriik.swap.ui.base.SwapAction

sealed class SelectSellingCurrencyAction : SwapAction {
    object LoadCurrencies : SelectSellingCurrencyAction()
    class SearchChanged(val query: String) : SelectSellingCurrencyAction()
    class CurrencySelected(val currency: SellingCurrencyData) : SelectSellingCurrencyAction()
}