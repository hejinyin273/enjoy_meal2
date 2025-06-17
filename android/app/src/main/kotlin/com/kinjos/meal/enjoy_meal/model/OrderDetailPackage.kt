package com.kinjos.meal.enjoy_meal.model

data class OrderDetailPackage(val packageId : Int,
                              val orderPackageId : Int,
                              val packageNameZh : String,
                              val packageNameJa : String,
                              val packageNameEn : String,
                              val packageQuantity : Int,
                              val unitPrice : Double,
                              val orderDetailDishes : List<OrderDetailDish>)  {

    override fun toString(): String {
        return "OrderDetailPackage(packageId=$packageId, orderPackageId=$orderPackageId, packageNameZh='$packageNameZh', packageNameJa='$packageNameJa', packageNameEn='$packageNameEn', packageQuantity=$packageQuantity, unitPrice=$unitPrice)"
    }

    fun getPackageTotalPrice() : Double {
        var totalPrice = 0.0
        totalPrice += (unitPrice * packageQuantity)

        for (i in orderDetailDishes.indices) {
            val dishInfo = orderDetailDishes[i]
            for (j in dishInfo.dishAttrs.indices) {
                val attrInfo = dishInfo.dishAttrs[j]
                totalPrice += (attrInfo.attributeUnitPrice * packageQuantity)
            }
        }
        return packageQuantity * unitPrice
    }

    fun getPackagePrintArray(): Array<String> {
        val printArray = arrayOf(
            packageNameJa,
            "${unitPrice.toInt()}",
            "$packageQuantity",
            "${getPackageTotalPrice()}",
        )
        return printArray
    }

    fun getPackageDishPrintList(): List<Array<String>> {
        var printList = mutableListOf<Array<String>>()
        for (i in orderDetailDishes.indices) {
            val dishInfo = orderDetailDishes[i]
            printList.add(dishInfo.getDishPrintArray())
        }
        return printList
    }

}
