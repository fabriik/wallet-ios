package com.fabriik.swap.ui.buyingCurrency

import com.fabriik.swap.data.model.BuyingCurrencyData
import com.fabriik.swap.data.model.SellingCurrencyData
import com.fabriik.swap.ui.base.SwapState

data class SelectBuyingCurrencyState(
    val title: String,
    val isLoading: Boolean = false,
    val currencies: List<BuyingCurrencyData> = listOf(),
    val errorMessage: String? = null
): SwapState