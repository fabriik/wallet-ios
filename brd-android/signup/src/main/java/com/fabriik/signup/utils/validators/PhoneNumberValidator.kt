package com.fabriik.signup.utils.validators

import android.util.Patterns

object PhoneNumberValidator : Validator {

    private val pattern = Patterns.PHONE

    override fun invoke(input: String) = pattern.matcher(input).matches()
}