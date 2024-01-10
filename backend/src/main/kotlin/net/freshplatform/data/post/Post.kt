package net.freshplatform.data.post

import java.time.LocalDateTime

data class Post(
    val createdAt: LocalDateTime,
    val message: String,
    val id: String
)