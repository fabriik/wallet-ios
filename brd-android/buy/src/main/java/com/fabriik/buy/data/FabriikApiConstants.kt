package com.fabriik.buy.data

object FabriikApiConstants {

    const val HOST = "one-dev.moneybutton.io/blocksatoshi"

    private const val BASE_URL = "https://$HOST"

    const val HOST_WYRE_API = "$BASE_URL/wyre/"
    const val HOST_WALLET_API = "$BASE_URL/wallet"
    const val HOST_BLOCKSATOSHI_API = "$BASE_URL/blocksatoshi"

    const val ENDPOINT_CURRENCIES = "$HOST_WALLET_API/currencies"

    val SUPPORTED_SWAP_CURRENCIES = arrayListOf(
        "eth", "btc", "bch", "bsv", "usdt20"
    )
}