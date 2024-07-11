package net.freshplatform.utils.extensions

import io.ktor.http.*
import io.ktor.server.util.*
import net.freshplatform.utils.response.ErrorResponseException

/**
 * Get the `limit` query parameter, it will be limited between 0 and 100
 * to prevent the client from getting all the data all at once
 *
 * it will throw [ErrorResponseException] if invalid value is given.
 * */
val Parameters.limit: Int
    get() {
        val limit: Int by this
        if (limit < 1) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "The limit parameter can't be less than 1",
                "INVALID_VALUE"
            )
        }
        if (limit > 100) {
            throw ErrorResponseException(
                HttpStatusCode.BadRequest,
                "The limit parameter can't be more than 100",
                "INVALID_VALUE"
            )
        }
        return limit.coerceIn(1..100)
    }