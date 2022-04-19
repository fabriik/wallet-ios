package com.fabriik.signup.data.requests

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ConfirmRegistrationRequest(
    @Json(name = "sessionKey")
    val sessionKey: String,

    @Json(name = "confirmation_code")
    val confirmationCode: String
)