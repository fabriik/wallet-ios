package com.fabriik.swap.utils

import android.widget.ImageView
import androidx.annotation.ColorRes
import androidx.core.content.ContextCompat
import androidx.core.graphics.drawable.DrawableCompat
import androidx.core.os.bundleOf
import androidx.lifecycle.SavedStateHandle
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

internal fun SavedStateHandle.toBundle() = bundleOf(
    *keys().map {
        Pair(it, get(it) as Any?)
    }.toTypedArray()
)