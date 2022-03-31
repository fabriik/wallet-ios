package com.fabriik.swap.ui.selectAmount

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.ui.base.SwapEffect
import java.math.BigDecimal

sealed class SelectAmountEffect : SwapEffect {
    object GoToHome : SelectAmountEffect()
    object GoBack : SelectAmountEffect()
    class GoToPreview(
        val sellingCurrency: SwapCurrency,
        val buyingCurrency: SwapCurrency,
        val amount: BigDecimal
    ) : SelectAmountEffect()
}