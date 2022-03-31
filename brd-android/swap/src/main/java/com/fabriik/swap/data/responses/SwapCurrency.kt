package com.fabriik.swap.data.responses

import android.os.Parcelable
import com.squareup.moshi.Json
import kotlinx.parcelize.Parcelize
import java.util.*

@Parcelize
data class SwapCurrency(
    @Json(name = "name")
    val name: String,

    @Json(name = "fullName")
    val fullName: String,

    @Json(name = "image")
    val image: String
) : Parcelable {

    fun formatCode() = name.toUpperCase(Locale.ROOT)
}