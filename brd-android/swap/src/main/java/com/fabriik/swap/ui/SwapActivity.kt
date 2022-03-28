package com.fabriik.swap.ui

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.fabriik.swap.R

class SwapActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_swap)
    }

    companion object {
        fun getStartIntent(context: Context) = Intent(context, SwapActivity::class.java)
    }
}