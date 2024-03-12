package net.freshplatform.utils.extensions

import net.freshplatform.utils.constants.PatternsConstants
import net.freshplatform.utils.helpers.PatternsHelper
import kotlinx.serialization.builtins.serializer
import kotlinx.serialization.json.Json
import java.io.File
import java.util.regex.Pattern

fun String.isValidEmail() = PatternsHelper.EMAIL_ADDRESS.matcher(this).matches()
fun String.toPattern(): Pattern = Pattern.compile(this)
fun String.matchPattern(pattern: String): Boolean = pattern.toPattern().matcher(this).matches()
fun String.isPasswordStrong() = this.matchPattern(PatternsConstants.PASSWORD)
fun getUserWorkingDirectory(): String {
    return System.getProperty("user.dir")
//    if (!isProductionServer()) {
//        return File(".").canonicalPath
//    }
//    return File(object {}.javaClass.protectionDomain.codeSource.location.toURI().path).parent
}
fun String.getFileFromUserWorkingDirectory(): File = File(getUserWorkingDirectory(), this)
fun String.toJson(): String = Json.encodeToString(String.serializer(), this)