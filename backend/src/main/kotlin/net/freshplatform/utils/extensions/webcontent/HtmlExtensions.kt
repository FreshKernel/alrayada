package net.freshplatform.utils.extensions.webcontent

import net.freshplatform.utils.constants.Constants
import kotlinx.html.*

fun HTML.webContentHeader(title: String) = head {
    title(title)
    styleLink("/style.css")
    meta("viewport", "user-scalable=no, width=device-width, initial-scale=1.0")
    meta("description", Constants.DESCRIPTION)
    meta(charset = "UTF-8")

    meta("apple-mobile-web-app-capable", "yes")
    meta("apple-mobile-web-app-status-bar-style", "black")
    meta("apple-mobile-web-app-title", title)
//    link(rel = "icon", type = "image/png", href = "")
//                link("http://localhost:8080/static/style.css", rel = LinkRel.stylesheet, type = LinkType.textCss)
}