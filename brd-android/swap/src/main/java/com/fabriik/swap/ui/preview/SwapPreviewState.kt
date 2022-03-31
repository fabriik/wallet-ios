package com.fabriik.swap.ui.preview

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapState
import java.math.BigDecimal

data class SwapPreviewState(
    val amount: BigDecimal,
    val buyingCurrency: SwapCurrency,
    val sellingCurrency: SwapCurrency,
    val errorMessage: String? = null
): SwapState