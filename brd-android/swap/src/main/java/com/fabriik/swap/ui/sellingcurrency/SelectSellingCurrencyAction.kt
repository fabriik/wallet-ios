package com.fabriik.swap.ui.sellingcurrency

import com.fabriik.swap.ui.SwapViewModel

sealed class SelectSellingCurrencyAction {
    object LoadCurrencies : SelectSellingCurrencyAction()
    class SearchChanged(val query: String) : SelectSellingCurrencyAction()
    class CurrencySelected(val currency: SwapViewModel.SellingCurrencyData) : SelectSellingCurrencyAction()
}