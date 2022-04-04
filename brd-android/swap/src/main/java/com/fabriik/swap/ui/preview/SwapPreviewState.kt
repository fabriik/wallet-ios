package com.fabriik.swap.ui.preview

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.data.responses.SwapExchangeAmount
import com.fabriik.swap.ui.base.SwapState
import java.math.BigDecimal

data class SwapPreviewState(
    val amount: BigDecimal,
    val isLoading: Boolean = false,
    val isContentVisible: Boolean = false,
    val buyingCurrency: SwapCurrency,
    val sellingCurrency: SwapCurrency,
    val errorMessage: String? = null,
    val exchangeData: SwapExchangeAmount? = null
): SwapState