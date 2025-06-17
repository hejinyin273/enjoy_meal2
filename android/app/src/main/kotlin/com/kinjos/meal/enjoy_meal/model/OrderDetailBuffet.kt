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
}


