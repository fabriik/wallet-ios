package com.fabriik.signup.data.requests

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class RegisterRequest(
    @Json(name = "first_name")
    val firstName: String,

    @Json(name = "last_name")
    val lastName: String,

    @Json(name = "phone")
    val phone: String,

    @Json(name = "email")
    val email: String,

    @Json(name = "encryptsha512hex_password")
    val password: String
)