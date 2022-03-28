package com.fabriik.swap.data.responses

import com.squareup.moshi.Json

data class SwapCurrency(
    @Json(name = "name")
    val name: String,

    @Json(name = "fullName")
    val fullName: String,

    @Json(name = "image")
    val image: String
)