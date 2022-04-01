package com.fabriik.swap.data.responses

import android.os.Parcelable
import com.squareup.moshi.Json
import kotlinx.parcelize.Parcelize
import java.math.BigDecimal
import java.util.*

@Parcelize
data class SwapExchangeAmount(
    @Json(name = "from")
    val from: String,

    @Json(name = "to")
    val to: String,

    @Json(name = "amount")
    val amount: BigDecimal,

    @Json(name = "result")
    val result: BigDecimal,

    @Json(name = "fee")
    val fee: BigDecimal,

    @Json(name = "rate")
    val rate: BigDecimal
) : Parcelable