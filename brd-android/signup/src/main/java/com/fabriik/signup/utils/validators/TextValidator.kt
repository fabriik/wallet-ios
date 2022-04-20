package com.fabriik.signup.utils.validators

object TextValidator : Validator {

    override fun invoke(input: String) = input.length > 2
}