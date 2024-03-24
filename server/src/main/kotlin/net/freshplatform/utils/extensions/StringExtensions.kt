package net.freshplatform.utils.extensions

import net.freshplatform.Constants

fun String.isValidPhoneNumber() = Constants.Patterns.PHONE_NUMBER.toPattern().matcher(this).matches()
fun String.isValidEmailAddress() = Constants.Patterns.EMAIL_ADDRESS.toPattern().matcher(this).matches()
fun String.isValidPassword() = Constants.Patterns.PASSWORD.toPattern().matcher(this).matches()