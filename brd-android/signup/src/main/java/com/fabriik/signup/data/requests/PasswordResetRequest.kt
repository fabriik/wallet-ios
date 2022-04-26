package com.fabriik.signup.data.requests

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class PasswordResetRequest(
    @Json(name = "key")
    val key: String,

    @Json(name = "password")
    val password: String
)