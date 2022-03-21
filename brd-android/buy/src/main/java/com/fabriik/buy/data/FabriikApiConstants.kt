package com.fabriik.buy.data

import com.fabriik.buy.BuildConfig

object FabriikApiConstants {

    val HOST = when {
        BuildConfig.DEBUG -> "one-dev.moneybutton.io/blocksatoshi"
        else -> "one-dev.moneybutton.io/blocksatoshi" //todo: change endpoint to production
    }

    private val BASE_URL = "https://$HOST"

    val HOST_WYRE_API = "$BASE_URL/wyre/"
    val HOST_WALLET_API = "$BASE_URL/wallet"
    val HOST_BLOCKSATOSHI_API = "$BASE_URL/blocksatoshi"

    val ENDPOINT_CURRENCIES = "$HOST_WALLET_API/currencies"
}