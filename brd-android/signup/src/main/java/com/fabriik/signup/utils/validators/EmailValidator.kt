package com.fabriik.signup.utils.validators

import android.util.Patterns

object EmailValidator : Validator {

    private val pattern = Patterns.EMAIL_ADDRESS

    override fun invoke(input: String) = pattern.matcher(input).matches()
}