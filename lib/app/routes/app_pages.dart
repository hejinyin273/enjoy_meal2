import 'package:enjoy_meal/app/ui/main/views/dish_detail_view.dart';
import 'package:enjoy_meal/app/ui/main/views/shopping_cart_view.dart';
import 'package:enjoy_meal/app/ui/waiter/views/cooking_manager_view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../ui/call/bindings/call_assistant_binding.dart';
import '../ui/call/views/call_assistant_view.dart';
import '../ui/login/bindings/login_binding.dart';
import '../ui/login/views/login_view.dart';
import '../ui/main/bindings/dish_detail_binding.dart';
import '../ui/main/bindings/main_binding.dart';
import '../ui/main/bindings/main_dish_binding.dart';
import '../ui/main/bindings/order_list_binding.dart';
import '../ui/main/bindings/select_diners_binding.dart';
import '../ui/main/bindings/select_set_menu_binding.dart';
import '../ui/main/bindings/buffet_confirm_binding.dart';
import '../ui/main/bindings/shopping_cart_binding.dart';
import '../ui/main/bindings/sub_dish_binding.dart';
import '../ui/main/views/main_dish_view.dart';
import '../ui/main/views/main_view.dart';
import '../ui/main/views/order_list_view.dart';
import '../ui/main/views/select_diners_view.dart';
import '../ui/main/views/select_set_menu_view.dart';
import '../ui/main/views/buffet_confirm_view.dart';
import '../ui/main/views/sub_dish_view.dart';
import '../ui/splash/bindings/splash_binding.dart';
import '../ui/splash/views/splash_view.dart';
import '../ui/waiter/bindings/cooking_manager_binding.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splashPage;

  static final routes = [
    GetPage(
      name: _Paths.mainPage,
      page: () => MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.loginPage,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.splashPage,
      page: () => SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.callAssistantPage,
      page: () => CallAssistantView(),
      binding: CallAssistantBinding(),
    ),
    GetPage(
      name: _Paths.mainDishPage,
      page: () => MainDishView(),
      binding: MainDishBinding(),
    ),
    GetPage(
      name: _Paths.subDishPage,
      page: () => SubDishView(),
      binding: SubDishBinding(),
    ),
    GetPage(
      name: _Paths.dishDetailPage,
      page: () => DishDetailView(),
      binding: DishDetailBinding(),
    ),
    GetPage(
      name: _Paths.selectSetMenuPage,
      page: () => SelectSetMenuView(),
      binding: SelectSetMenuBinding(),
    ),
    GetPage(
      name: _Paths.shoppingCartPage,
      page: () => ShoppingCartView(),
      binding: ShoppingCartBinding(),
    ),
    GetPage(
      name: _Paths.orderListPage,
      page: () => OrderListView(),
      binding: OrderListBinding(),
    ),
    GetPage(
      name: _Paths.cookingManagerPage,
      page: () => CookingManagerView(),
      binding: CookingManagerBinding(),
    ),
    GetPage(
      name: _Paths.buffetConfirmPage,
      page: () => BuffetConfirmView(),
      binding: BuffetConfirmBinding(),
    ),
    GetPage(
      name: _Paths.selectDinersPage,
      page: () => SelectDinersView(),
      binding: SelectDinersBinding(),
    ),
  ];
}


abstract class Routes {
  Routes._();
  static const mainPage = _Paths.mainPage;
  static const loginPage = _Paths.loginPage;
  static const splashPage = _Paths.splashPage;
  static const callAssistantPage = _Paths.callAssistantPage;
  static const mainDishPage = _Paths.mainDishPage;
  static const subDishPage = _Paths.subDishPage;
  static const dishDetailPage = _Paths.dishDetailPage;
  static const selectSetMenuPage = _Paths.selectSetMenuPage;
  static const shoppingCartPage = _Paths.shoppingCartPage;
  static const orderListPage = _Paths.orderListPage;
  static const cookingManagerPage = _Paths.cookingManagerPage;
  static const buffetConfirmPage = _Paths.buffetConfirmPage;
  static const selectDinersPage = _Paths.selectDinersPage;
}

abstract class _Paths {
  static const mainPage = '/mainPage';
  static const loginPage = '/loginPage';
  static const splashPage = '/splashPage';
  static const callAssistantPage = '/callAssistantPage';
  static const mainDishPage = '/mainDishPage';
  static const subDishPage = '/subDishPage';
  static const dishDetailPage = '/dishDetailPage';
  static const selectSetMenuPage = '/selectSetMenuPage';
  static const shoppingCartPage = '/shoppingCartPage';
  static const orderListPage = '/orderListPage';
  static const cookingManagerPage = '/cookingManagerPage';
  static const buffetConfirmPage = '/buffetConfirmPage';
  static const selectDinersPage = '/selectDinersPage';
}
