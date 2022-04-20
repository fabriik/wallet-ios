package com.fabriik.signup.utils

import android.graphics.Color
import android.view.View
import androidx.annotation.StringRes
import com.google.android.material.snackbar.Snackbar

object SnackBarUtils {

    internal fun showLong(view: View, text: CharSequence) {
        show(
            Snackbar.make(
                view, text, Snackbar.LENGTH_LONG
            )
        )
    }

    internal fun showLong(view: View, @StringRes text: Int) {
        show(
            Snackbar.make(
                view, text, Snackbar.LENGTH_LONG
            )
        )
    }

    private fun show(snackBar: Snackbar) {
        snackBar.view.setOnClickListener {
            snackBar.dismiss()
        }
        snackBar.setTextColor(Color.WHITE)
        snackBar.show()
    }
}