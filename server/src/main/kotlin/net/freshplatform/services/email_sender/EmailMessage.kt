package net.freshplatform.services.email_sender

data class EmailMessage(
    val to: String,
    val subject: String,
    val body: String
)