package com.fabriik.swap.ui.sellingcurrency

import com.fabriik.swap.ui.SwapViewModel

data class SelectSellingCurrencyState(
    val isLoading: Boolean = false,
    val currencies: List<SwapViewModel.SellingCurrencyData> = listOf(),
    val errorMessage: String? = null
)