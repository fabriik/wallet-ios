package com.fabriik.signup.utils.validators

interface Validator {
    operator fun invoke(input: String): Boolean
}