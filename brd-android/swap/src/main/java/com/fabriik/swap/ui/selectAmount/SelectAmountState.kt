package com.fabriik.swap.ui.selectAmount

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapState
import java.math.BigDecimal

data class SelectAmountState(
    val title: String,
    val receivedAmount: BigDecimal = BigDecimal.ZERO,
    val buyingCurrency: SwapCurrency,
    val sellingCurrency: SwapCurrency,
    val errorMessage: String? = null
): SwapState