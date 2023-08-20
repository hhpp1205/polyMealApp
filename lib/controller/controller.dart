import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:poly_meal/controller/school_controller.dart';
import 'package:poly_meal/controller/school_menu_controller.dart';
import 'package:poly_meal/controller/selected_date_controller.dart';
import 'package:poly_meal/model/menu.dart';

class Controller extends GetxController {
  late final SchoolController schoolController;
  late final SchoolMenuController schoolMenuController;
  late final SelectedDateController selectedDateController;

  @override
  void onInit() {
    schoolController = Get.put(SchoolController());
    schoolMenuController = Get.put(SchoolMenuController());
    selectedDateController = Get.put(SelectedDateController());
  }

  // SchoolController
  Rx<String> getSchoolCode()  => schoolController.schoolCode;
  RxMap<String, String> getSchoolCodeMap() => schoolController.schoolCodeMap;

  // SchoolMenuController
  Rx<Menu> getMenu() => schoolMenuController.menu;

  RxBool getIsMenuLoading() => schoolMenuController.isMenuLoading;

  // SelectedDateController
  Rx<DateTime> getSelectedDate() => selectedDateController.selectedDate;
  RxBool getIsDragEnable() => selectedDateController.isDragEnable;


  void onVerticalDragEndDate(DragEndDetails details) async {
    if(getIsDragEnable().value) return;

    getIsDragEnable().value = true;

    if(details.velocity.pixelsPerSecond.dy > 0) {
      selectedDateController.updateSelectedDateToToday();
    }
    schoolMenuController.getMenuApi(getSchoolCode().value, getSelectedDate().value);
    getIsDragEnable().value = false;
  }

  void onHorizontalDragEndDate(DragEndDetails details) {
    if(getIsDragEnable().value) return;

    getIsDragEnable().value = true;

    if (details.velocity.pixelsPerSecond.dx > 0) {
      selectedDateController.decrementSelectedDate();
    } else if(details.velocity.pixelsPerSecond.dx < 0) {
      selectedDateController.increaseSelectedDate();
    }
    print("selectedDate = ${getSelectedDate()}");
    schoolMenuController.getMenuApi(getSchoolCode().value, getSelectedDate().value);
    getIsDragEnable().value = false;
  }

}