package com.fabriik.signup.data.responses

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class UserApiResponse<T>(
    @Json(name = "result")
    val result: String,

    @Json(name = "error")
    val error: UserApiResponseError?,

    @Json(name = "data")
    val data: T?,
)

@JsonClass(generateAdapter = true)
data class UserApiResponseError(
    @Json(name = "code")
    val code: String,

    @Json(name = "server_message")
    val message: String
)