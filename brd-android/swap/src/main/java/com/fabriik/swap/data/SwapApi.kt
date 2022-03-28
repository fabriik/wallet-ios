package com.fabriik.swap.data

import com.fabriik.swap.data.responses.SwapCurrency
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class SwapApi(private val service: SwapService) {

    suspend fun getCurrencies() : List<SwapCurrency> {
        return listOf(
            SwapCurrency(
                fullName = "Bitcoin",
                image = "https://web-api.changelly.com/api/coins/btc.png",
                name = "btc"
            ),

            SwapCurrency(
                fullName = "Ethereum",
                image = "https://web-api.changelly.com/api/coins/eth.png",
                name = "eth"
            ),

            SwapCurrency(
                fullName = "Bitcoin SV",
                image = "https://web-api.changelly.com/api/coins/bsv.png",
                name = "bsv"
            ),

            SwapCurrency(
                fullName = "Bitcoin Cash",
                image = "https://web-api.changelly.com/api/coins/bch.png",
                name = "bch"
            ),

            SwapCurrency(
                fullName = "XRP",
                image = "https://web-api.changelly.com/api/coins/xrp.png",
                name = "xrp"
            )
        )
    }

    companion object {
        fun create() = SwapApi(
            Retrofit.Builder()
                .baseUrl("https://localhost") //todo: change env
                .addConverterFactory(MoshiConverterFactory.create())
                .build()
                .create(SwapService::class.java)
        )
    }
}