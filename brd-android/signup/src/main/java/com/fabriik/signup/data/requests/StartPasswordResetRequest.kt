package com.fabriik.signup.data.requests

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class StartPasswordResetRequest(
    @Json(name = "username")
    val username: String
)