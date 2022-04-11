package com.fabriik.trade.ui

import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.core.widget.ContentLoadingProgressBar
import com.fabriik.trade.R
import java.lang.IllegalStateException
import java.lang.StringBuilder

class TradeWebViewActivity : AppCompatActivity() {

    companion object {
        private const val LIST_COINS_SUPPORTED = "LIST_COINS_SUPPORTED"

        fun newIntent(context: Context, coins: List<String>): Intent {
            val intent = Intent(context, TradeWebViewActivity::class.java)
            intent.putStringArrayListExtra(LIST_COINS_SUPPORTED, ArrayList(coins))
            return intent
        }
    }

    private lateinit var webView: WebView
    private lateinit var loadingIndicator: ContentLoadingProgressBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_trade_web_view)

        webView = findViewById(R.id.web_view)
        loadingIndicator = findViewById(R.id.loading_bar)

        webView.settings.apply {
            domStorageEnabled = true
            javaScriptEnabled = true
        }

        webView.webViewClient = object : WebViewClient() {
            override fun shouldOverrideUrlLoading(
                view: WebView,
                request: WebResourceRequest
            ): Boolean {
                view.loadUrl(request.url.toString())
                return true
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                loadingIndicator.isVisible = false
            }
        }

        loadWidget()
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }

    private fun loadWidget() {
        val currencies = intent?.extras?.getStringArrayList(
            LIST_COINS_SUPPORTED
        ) ?: emptyList()

        if (currencies.isEmpty()) {
            throw IllegalStateException("List of supported currencies is empty")
        }

        val url = buildUrl(currencies)
        webView.loadUrl(url.toString())
    }

    private fun buildUrl(supportedCurrencies: List<String>): Uri {
        val merchantId = "NGVQYXnFp13iKtj1"
        val currencies = supportedCurrencies.joinToString(",")

        return Uri.Builder()
            .scheme("https")
            .authority("widget.changelly.com")
            .appendQueryParameter("to", currencies)
            .appendQueryParameter("from", currencies)
            .appendQueryParameter("toDefault", "eth")
            .appendQueryParameter("fromDefault", "btc")
            .appendQueryParameter("amount", "1")
            .appendQueryParameter("theme", "default")
            .appendQueryParameter("merchant_id", merchantId)
            .appendQueryParameter("v", "3")
            .build()
    }
}