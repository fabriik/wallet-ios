package com.fabriik.swap.ui.sellingcurrency

import com.fabriik.swap.data.model.SellingCurrencyData
import com.fabriik.swap.ui.base.SwapState

data class SelectSellingCurrencyState(
    val isLoading: Boolean = false,
    val currencies: List<SellingCurrencyData> = listOf(),
    val errorMessage: String? = null
): SwapState