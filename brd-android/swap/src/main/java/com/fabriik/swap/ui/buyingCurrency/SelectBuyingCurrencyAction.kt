package com.fabriik.swap.ui.buyingCurrency

import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.data.model.SellingCurrencyData
import com.fabriik.swap.ui.base.SwapAction

sealed class SelectBuyingCurrencyAction : SwapAction {
    object Back : SelectBuyingCurrencyAction()
    object Close : SelectBuyingCurrencyAction()
    object LoadCurrencies : SelectBuyingCurrencyAction()
    class SearchChanged(val query: String) : SelectBuyingCurrencyAction()
    class CurrencySelected(val currency: BuyingCurrencyData) : SelectBuyingCurrencyAction()
}