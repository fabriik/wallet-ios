package com.fabriik.trade.ui

import android.os.Bundle
import android.webkit.WebResourceRequest
import android.webkit.WebView
import android.webkit.WebViewClient
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.core.widget.ContentLoadingProgressBar
import com.fabriik.trade.R

class TradeWebViewActivity : AppCompatActivity() {

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
                return true
            }

            override fun onPageFinished(view: WebView?, url: String?) {
                super.onPageFinished(view, url)
                loadingIndicator.isVisible = false
            }
        }

        webView.loadUrl("https://widget.changelly.com?from=btc&to=eth&amount=1&address=&fromDefault=btc&toDefault=eth&theme=default&merchant_id=NGVQYXnFp13iKtj1&payment_id=&v=3")
    }

    override fun onBackPressed() {
        if (webView.canGoBack()) {
            webView.goBack()
        } else {
            super.onBackPressed()
        }
    }
}