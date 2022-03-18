package com.fabriik.buy.data.requests

import com.squareup.moshi.Json

data class ReservationUrlRequest(
    @Json(name = "redirectUrl")
    val redirectUrl: String,

    @Json(name = "failureRedirectUrl")
    val failureRedirectUrl: String,

    @Json(name = "referrerAccountId")
    val referrerAccountId: String
)