package com.fabriik.signup.utils

import android.content.res.ColorStateList
import android.graphics.Paint
import android.text.Spanned
import android.text.TextPaint
import android.text.method.LinkMovementMethod
import android.text.style.ClickableSpan
import android.view.View
import android.widget.EditText
import android.widget.TextView
import androidx.core.content.ContextCompat
import androidx.core.text.toSpannable
import com.fabriik.signup.R

internal fun TextView.underline() {
    paintFlags = paintFlags or Paint.UNDERLINE_TEXT_FLAG
}

internal fun TextView.clickableSpan(fullTextRes: Int, clickableParts: Map<Int, () -> Unit>, underline: Boolean = true) {
    val clickablePartsAsStrings = clickableParts.map {
        context.getString(it.key) to it.value
    }.toMap()

    val clickableTexts = clickablePartsAsStrings.keys.toTypedArray()
    val fullText = context.getString(fullTextRes, *clickableTexts)
    val spannable = fullText.toSpannable()

    clickablePartsAsStrings.forEach {
        val startIndex = fullText.indexOf(it.key)
        val endIndex = startIndex + it.key.length

        val clickableSpan = object: ClickableSpan() {
            override fun onClick(widget: View) {
                it.value()
            }

            override fun updateDrawState(ds: TextPaint) {
                super.updateDrawState(ds)
                ds.isUnderlineText = underline
            }
        }

        spannable.setSpan(
            clickableSpan, startIndex, endIndex, Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
        )
    }

    text = spannable
    movementMethod = LinkMovementMethod.getInstance()
}

internal fun EditText.setInputValid(valid: Boolean) {
    backgroundTintList = ColorStateList.valueOf(
        if (valid) {
            R.color.fabriik_green
        } else {
            R.color.fabriik_gray_1
        }
    )


    val drawable = if (valid) {
        ContextCompat.getDrawable(
            context, R.drawable.ic_check_mark_blue
        )
    } else {
        null
    }

    setCompoundDrawablesRelativeWithIntrinsicBounds(
        null, null, drawable, null
    )
}