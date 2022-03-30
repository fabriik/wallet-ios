package com.fabriik.swap.utils

import android.widget.ImageView
import androidx.annotation.ColorRes
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import com.squareup.picasso.Callback
import com.squareup.picasso.Picasso
import java.lang.Exception

internal fun ImageView.loadFromUrl(url: String, @ColorRes tintColor: Int? = null) {
    Picasso.get()
        .load(url)
        .into(this, object: Callback {
            override fun onSuccess() {
                tintColor?.let {
                    DrawableCompat.setTint(
                        this@loadFromUrl.drawable,
                        ContextCompat.getColor(context, it)
                    )
                }
            }

            override fun onError(e: Exception?) {}
        })
}