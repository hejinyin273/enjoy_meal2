package com.kinjos.meal.enjoy_meal.model

data class OrderDetailResp(
    val orderNumber:String,
    val totalAmount: Double,
    val firstOrderTime: String?,
    val buffetEndTime: String?,
    val orderDetailPackages: List<OrderDetailPackage>,
    val orderDetailBuffets: List<OrderDetailBuffet>,
    val orderDetailDishes: List<OrderDetailDish>
) {
    override fun toString(): String {
        return "OrderDetailResp(orderNumber='$orderNumber', totalAmount=$totalAmount, firstOrderTime=$firstOrderTime, buffetEndTime=$buffetEndTime, orderDetailPackages=$orderDetailPackages, orderDetailDishes=$orderDetailDishes)"
    }

    fun getPrintList(): List<Array<String>> {
        var printList = mutableListOf<Array<String>>()
        for (i in orderDetailPackages.indices) {
            val packageInfo = orderDetailPackages[i]
            printList.add(packageInfo.getPackagePrintArray())
            printList.addAll(packageInfo.getPackageDishPrintList())
        }

        for (i in orderDetailDishes.indices) {
            val dishInfo = orderDetailDishes[i]
            printList.add(dishInfo.getDishPrintArray())
        }
        return printList
    }
}

