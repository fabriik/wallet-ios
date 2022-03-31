package com.fabriik.swap.data.model

import com.fabriik.swap.data.responses.SwapCurrency
import java.math.BigDecimal

data class BuyingCurrencyData(
    val currency: SwapCurrency,
    val rate: BigDecimal
)