package com.fabriik.swap.ui.selectAmount

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapState

data class SelectAmountState(
    val title: String,
    val buyingCurrency: SwapCurrency,
    val sellingCurrency: SwapCurrency,
    val errorMessage: String? = null
): SwapState