package net.freshplatform.routes.orders

import kotlinx.serialization.Serializable

@Serializable
data class MonthlyTotal(val month: Int, val total: Double)
