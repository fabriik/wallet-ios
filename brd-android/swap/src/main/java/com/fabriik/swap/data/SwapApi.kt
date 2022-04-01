package com.fabriik.swap.data

import com.fabriik.swap.data.responses.SwapCurrency
import com.fabriik.swap.data.responses.SwapExchangeAmount
import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory
import java.math.BigDecimal
import java.util.*

class SwapApi(private val service: SwapService) {

    suspend fun getCurrencies() : List<SwapCurrency> {
        //todo: call api
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

    suspend fun getExchangeAmounts(from: SwapCurrency, to: List<SwapCurrency>, amount: BigDecimal) : List<SwapExchangeAmount> {
        //todo: call api
        return to.map {
            SwapExchangeAmount(
                to = it.name,
                from = from.name,
                amount = amount,
                result = BigDecimal(Random().nextDouble()),
                fee = BigDecimal.ONE,
                rate = BigDecimal.TEN
            )
        }
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