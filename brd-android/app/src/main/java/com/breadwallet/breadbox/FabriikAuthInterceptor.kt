package com.breadwallet.breadbox

import com.breadwallet.BuildConfig
import okhttp3.Interceptor
import okhttp3.Response

class FabriikAuthInterceptor : Interceptor {

    override fun intercept(chain: Interceptor.Chain): Response {
        /*if (!chain.request().url.host.endsWith("moneybutton.io")) {
            return chain.proceed(chain.request())
        }*/

        return chain.request()
            .newBuilder()
            .addHeader("Authorization", "829crj6obirtjq4sir0rdlrbdnp1hlramh3oqfq1")
            .build()
            .run(chain::proceed)
    }
}