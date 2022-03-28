package com.fabriik.swap.data

import retrofit2.Retrofit
import retrofit2.converter.moshi.MoshiConverterFactory

class SwapApi(private val service: SwapService) {

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