package com.fabriik.swap.ui

import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.webkit.WebView
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.isVisible
import androidx.core.widget.ContentLoadingProgressBar
import androidx.lifecycle.ViewModelProvider
import com.fabriik.swap.R
import com.fabriik.swap.data.Status

class SwapActivity : AppCompatActivity() {

    private lateinit var webView: WebView
    private lateinit var viewModel: SwapViewModel
    private lateinit var loadingIndicator: ContentLoadingProgressBar

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_swap)

        viewModel = ViewModelProvider(this)
            .get(SwapViewModel::class.java)

        webView = findViewById(R.id.web_view)
        loadingIndicator = findViewById(R.id.loading_bar)

        viewModel.getCurrencies().observe(this) {
            when (it.status) {
                Status.SUCCESS -> {
                    it.data?.let { response ->

                    }
                }
                Status.ERROR -> {
                    finishWithResult(RESULT_ERROR)
                }
                Status.LOADING -> {
                    loadingIndicator.isVisible = true
                }
            }
        }
    }

    private fun finishWithResult(resultCode: Int) {
        setResult(resultCode)
        finish()
    }

    companion object {
        const val RESULT_ERROR = 2131
        const val RESULT_SUCCESS = 2132
        const val RESULT_CANCELED = 2133

        fun getStartIntent(context: Context) = Intent(context, SwapActivity::class.java)
    }
}