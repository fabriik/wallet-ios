package com.fabriik.trade.ui

import android.app.Activity
import android.graphics.Color
import androidx.browser.customtabs.CustomTabColorSchemeParams
import androidx.browser.customtabs.CustomTabsIntent
import java.lang.Exception

object TradeWebViewLauncher {

    private val DEFAULT_TABS_SCHEME = CustomTabColorSchemeParams.Builder()
        .setNavigationBarColor(Color.WHITE)
        .setToolbarColor(Color.WHITE)
        .build()

    fun launch(activity: Activity, currencies: List<String>) {
        try {
            val customTabsIntent = CustomTabsIntent.Builder()
                .setDefaultColorSchemeParams(DEFAULT_TABS_SCHEME)
                .build()

            customTabsIntent.launchUrl(activity, TradeUrlBuilder.build(currencies))
        } catch (ex: Exception) {
            activity.startActivity(
                TradeWebViewActivity.newIntent(
                    activity, currencies
                )
            )
        }
    }
}