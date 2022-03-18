package com.fabriik.buy.data

import com.fabriik.buy.data.requests.ReservationUrlRequest
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class WyreApi(private val service: WyreService) {

    private val secretKey = "SK-DH6XP4AX-ZQ3ULQ2G-6CVP3PF9-TFJ4N7VJ" //todo: move secret key

    suspend fun getPaymentUrl() = service.getPaymentUrl(
        auth = "Bearer $secretKey",
        timestamp = System.currentTimeMillis(),
        request = ReservationUrlRequest(
            redirectUrl = REDIRECT_URL,
            failureRedirectUrl = FAILURE_REDIRECT_URL,
            referrerAccountId = "AC_T6HMDWDGM8V", // todo: move account id
        )
    )

    companion object {

        const val REDIRECT_URL = "https://www.sendwyre.com/success"
        const val FAILURE_REDIRECT_URL = "https://www.sendwyre.com/error"

        fun create() = WyreApi(
            Retrofit.Builder()
                .baseUrl("https://api.testwyre.com") //todo: change env
                .addConverterFactory(MoshiConverterFactory.create())
                .build()
                .create(WyreService::class.java)
        )
    }
}