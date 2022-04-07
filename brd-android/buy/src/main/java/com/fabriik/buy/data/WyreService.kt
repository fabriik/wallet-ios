package com.fabriik.buy.data

import com.fabriik.buy.data.responses.ReservationUrlResponse
import retrofit2.http.*

interface WyreService {

    @GET("reserve")
    suspend fun getPaymentUrl(
        @Header("Authorization") auth: String,
        @Query("test") isTestNetwork: Boolean
    ) : ReservationUrlResponse
}