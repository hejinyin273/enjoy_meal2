package com.kinjos.meal.enjoy_meal.model

data class DishAttr(
    val id: Int,
    val attributeNameZh: String,
    val attributeNameJa: String,
    val attributeNameEn: String,
    val simpleName: String,
    val attributeUnitPrice: Double
    ) {
    override fun toString(): String {
        return "DishAttr(id=$id, attributeNameZh='$attributeNameZh', attributeNameJa='$attributeNameJa', attributeNameEn='$attributeNameEn', simpleName='$simpleName', attributeUnitPrice=$attributeUnitPrice)"
    }

    fun getPrintArray(): Array<String> {
        val printArray = arrayOf(
            attributeNameJa,
            "${attributeUnitPrice.toInt()}"
        )
        return printArray
    }
}


