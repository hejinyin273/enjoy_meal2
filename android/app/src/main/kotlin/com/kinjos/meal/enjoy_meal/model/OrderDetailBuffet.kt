package com.kinjos.meal.enjoy_meal.model

data class OrderDetailBuffet(
    val buffetCategoryId: Int,
    val buffetCategoryNameZh: String,
    val buffetCategoryNameJa: String,
    val buffetCategoryNameEn: String,
    val orderBuffetPriceDetails: List<OrderBuffetPriceDetail>
) {
    override fun toString(): String {
        return "OrderDetailBuffet(buffetCategoryId=$buffetCategoryId, buffetCategoryNameZh='$buffetCategoryNameZh', buffetCategoryNameJa='$buffetCategoryNameJa', buffetCategoryNameEn='$buffetCategoryNameEn', orderBuffetPriceDetails=$orderBuffetPriceDetails)"
    }

    private fun getPrintArray(): Array<String> {
        val printArray = arrayOf(
            buffetCategoryNameJa,
            "",
            "",
            "",
        )
        return printArray
    }

    fun getPrintList(): List<Array<String>> {
        var printList = mutableListOf<Array<String>>()

        printList.add(getPrintArray())

        for (i in orderBuffetPriceDetails.indices) {
            val orderBuffetPriceDetail = orderBuffetPriceDetails[i]
            printList.addAll(orderBuffetPriceDetail.getPrintList())
        }
        return printList
    }

}


