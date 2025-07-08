package com.kinjos.meal.enjoy_meal.model


data class OrderDetailResp(
    val orderNumber:String,
    val totalAmount: Double,
    val firstOrderTime: String?,
    val buffetEndTime: String?,
    val tableNumber: String,
    val dinerCount: Int,
    val firstDishTime: String?,
    val firstFoodOrderTime: String,
    val restaurantNameZh: String,
    val restaurantNameJa: String,
    val restaurantNameEn: String,
    val batchOrderNum: Int,
    val batchCount: Int,
    val totalPrice: Double,
    val orderDetailPackages: List<OrderDetailPackage>,
    val orderDetailBuffets: List<OrderDetailBuffet>,
    val orderDetailDishes: List<OrderDetailDish>
) {
    override fun toString(): String {
        return "OrderDetailResp(orderNumber='$orderNumber', totalPrice=$totalPrice, totalAmount=$totalAmount, batchOrderNum=$batchOrderNum, " +
                "firstOrderTime=$firstOrderTime, buffetEndTime=$buffetEndTime, orderDetailPackages=$orderDetailPackages, orderDetailDishes=$orderDetailDishes)"
    }

    fun isBuffet(): Boolean {
        return orderDetailBuffets.isNotEmpty()
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

        for (i in orderDetailBuffets.indices) {
            val orderDetailBuffet = orderDetailBuffets[i]
            printList.addAll(orderDetailBuffet.getPrintList())
        }

        return printList
    }
}

