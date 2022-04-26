package com.fabriik.signup.data.responses

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class LoginResponse(
    @Json(name = "sessionKey")
    val sessionKey: String,

    @Json(name = "is_confirmed")
    val isConfirmed: Boolean,

    @Json(name = "needMfaToken")
    val needMfaToken: Boolean,

    @Json(name = "authapp_enabled")
    val authAppEnabled: Int,

    @Json(name = "sms_enabled")
    val smsEnabled: Int,

    @Json(name = "email_enabled")
    val emailEnabled: Int,
)