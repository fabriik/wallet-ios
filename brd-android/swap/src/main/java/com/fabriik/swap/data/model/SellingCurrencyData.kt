package com.fabriik.swap.data.model

import com.fabriik.swap.data.responses.SwapCurrency
import java.math.BigDecimal

data class SellingCurrencyData(
    val currency: SwapCurrency,
    val fiatBalance: BigDecimal,
    val cryptoBalance: BigDecimal
)