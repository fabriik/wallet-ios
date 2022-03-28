package com.fabriik.swap.data.requests

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ReservationUrlRequest(
    @Json(name = "redirectUrl")
    val redirectUrl: String,

    @Json(name = "failureRedirectUrl")
    val failureRedirectUrl: String,

    @Json(name = "referrerAccountId")
    val referrerAccountId: String
)