import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class MainTabController extends GetxController {
  PersistentTabController mainTabController = PersistentTabController(
    initialIndex: 0,
  );

  void routing(int tab) {
    mainTabController.jumpToTab(tab);
  }
}
