import 'package:get/get.dart';

import '../data/local/db/database_manager.dart';
import '../data/local/db/database_manager_impl.dart';
import '../data/local/preference/preference_manager.dart';
import '../data/local/preference/preference_manager_impl.dart';



class LocalSourceBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreferenceManager>(
          () => PreferenceManagerImpl(),
      tag: (PreferenceManager).toString(),
      fenix: true,
    );

    Get.lazyPut<DatabaseManager>(
          () => DatabaseManagerImpl(),
      tag: (DatabaseManager).toString(),
      fenix: true,
    );
  }
}