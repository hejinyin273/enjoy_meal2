package com.kinjos.meal.enjoy_meal.model

data class OrderDetailDish(
    val orderDishId: Int,
    val id: Int,
    val dishNameZh: String,
    val dishNameJa: String,
    val dishNameEn: String,
    val simpleName: String,
    val dishQuantity: Int,
    val unitPrice: Double,
    val orderMode: Int,
    val status: Int,
    val dishAttrs: List<DishAttr>) {
    override fun toString(): String {
        return "OrderDetailDish(orderDishId=$orderDishId, id=$id, dishNameZh='$dishNameZh', dishNameJa='$dishNameJa', dishNameEn='$dishNameEn', simpleName='$simpleName', dishQuantity=$dishQuantity, unitPrice=$unitPrice, orderMode=$orderMode, status=$status, dishAttr=$dishAttrs)"
    }

    fun getTotalPrice(): Double {
        var totalPrice = 0.0
        totalPrice += (unitPrice * dishQuantity)
        for (i in dishAttrs.indices) {
            val attrInfo = dishAttrs[i]
            totalPrice += (attrInfo.attributeUnitPrice * dishQuantity)
        }
        return totalPrice
    }

    fun getDishPrintArray(): Array<String> {
        val printArray = arrayOf(
            "${dishNameJa}${getDishAttrNames()}",
            "${getTotalUnitPrice().toInt()}",
            "$dishQuantity",
            "${getTotalPrice().toInt()}",
        )
        return printArray
    }

    private fun getTotalUnitPrice(): Double {
        var totalPrice = unitPrice
        for (i in dishAttrs.indices) {
            val attrInfo = dishAttrs[i]
            totalPrice += attrInfo.attributeUnitPrice
        }
        return totalPrice
    }

    private fun getDishAttrNames(): String  {
        var attrNames = ""
        for (i in dishAttrs.indices) {
            val attrInfo = dishAttrs[i]
            attrNames += attrInfo.attributeNameJa
        }
        if (attrNames.isNotEmpty()) {
            attrNames = "($attrNames)"
        }
        return attrNames
    }

}

