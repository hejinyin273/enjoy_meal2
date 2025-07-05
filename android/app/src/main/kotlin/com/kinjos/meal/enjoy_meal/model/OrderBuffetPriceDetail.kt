package com.kinjos.meal.enjoy_meal.model

data class OrderBuffetPriceDetail(
    val buffetPriceId: Int,
    val orderBuffetId: Int,
    val dinerTypeNameZh: String,
    val dinerTypeNameJa: String,
    val dinerTypeNameEn: String,
    val unitPrice: Double,
    val totalDinerCount: Int,
    val extraTimeCount: Int,
    val overtimeExtraFee: Double
) {
    override fun toString(): String {
        return "OrderBuffetPriceDetail(buffetPriceId=$buffetPriceId, orderBuffetId=$orderBuffetId, dinerTypeNameZh='$dinerTypeNameZh', dinerTypeNameJa='$dinerTypeNameJa', dinerTypeNameEn='$dinerTypeNameEn', unitPrice=$unitPrice, totalDinerCount=$totalDinerCount, extraTimeCount=$extraTimeCount, overtimeExtraFee=$overtimeExtraFee)"
    }

    fun getPrintArray(): Array<String> {
        val printArray = arrayOf(
            dinerTypeNameJa,
            "${unitPrice.toInt()}",
            "$totalDinerCount",
            "${(totalDinerCount * unitPrice).toInt()}",
        )
        return printArray
    }

    fun getPrintList(): List<Array<String>> {
        var printList = mutableListOf<Array<String>>()
        val printArray = arrayOf(
            dinerTypeNameJa,
            "${unitPrice.toInt()}",
            "$totalDinerCount",
            "${(totalDinerCount * unitPrice).toInt()}",
        )
        printList.add(printArray)
        if (extraTimeCount > 0) {
            val printArray = arrayOf(
                "延長",
                "単価${overtimeExtraFee.toInt()}",
                "${extraTimeCount}回数",
                "${(extraTimeCount * overtimeExtraFee).toInt()}",
            )
            printList.add(printArray)
        }
        return printList
    }
}


