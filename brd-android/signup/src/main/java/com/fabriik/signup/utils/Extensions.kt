package com.fabriik.signup.utils

import android.graphics.Paint
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.View
import android.widget.TextView
import androidx.core.text.toSpannable

internal fun TextView.underline() {
    paintFlags = paintFlags or Paint.UNDERLINE_TEXT_FLAG
}

internal fun TextView.clickableSpan(fullTextRes: Int, clickableTextRes: Int, callback: () -> Unit, underline: Boolean = true) {
    val clickableText = context.getString(clickableTextRes)
    val fullText = context.getString(fullTextRes, clickableText)
    val clickableTextIndex = fullText.indexOf(clickableText)

    val clickableSpan = object: ClickableSpan() {
        override fun onClick(widget: View) {
            callback()
        }

        override fun updateDrawState(ds: TextPaint) {
            super.updateDrawState(ds)
            ds.isUnderlineText = underline
        }
    }

    val spannable = fullText.toSpannable()
    spannable.setSpan(clickableSpan, clickableTextIndex, fullText.length, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE)

    text = spannable
    movementMethod = LinkMovementMethod.getInstance()
}