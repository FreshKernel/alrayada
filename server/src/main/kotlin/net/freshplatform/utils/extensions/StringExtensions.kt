package net.freshplatform.utils.extensions

import io.ktor.http.*
import net.freshplatform.Constants
import java.net.URI

fun String.isValidPhoneNumber() = Constants.Patterns.PHONE_NUMBER.toPattern().matcher(this).matches()
fun String.isValidEmailAddress() = Constants.Patterns.EMAIL_ADDRESS.toPattern().matcher(this).matches()
fun String.isValidPassword() = Constants.Patterns.PASSWORD.toPattern().matcher(this).matches()
fun String.isHttpUrl(): Boolean {
    val scheme = URI.create(this).scheme
    return scheme == URLProtocol.HTTP.name || scheme == URLProtocol.HTTPS.name
}