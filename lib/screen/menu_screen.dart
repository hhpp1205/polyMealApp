import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:poly_meal/component/date_bar.dart';
import 'package:poly_meal/component/menu_box.dart';
import 'package:poly_meal/component/school_drawer.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/controller/controller.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late final Controller controller;

  @override
  void initState() {
    controller = Get.put(Controller());
    initData();
  }

  void initData() async {
    await controller.schoolController.isSchoolCodeNavigator();
    await controller.schoolMenuController.getMenuApi(controller.getSchoolCode().value, controller.getSelectedDate().value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_GRAY,
      appBar: AppBar(
        foregroundColor: COLOR_BLACK,
        backgroundColor: COLOR_GRAY,
        elevation: 0.0,
        title: Align(
          alignment: Alignment.centerRight,
          child: Obx(() => Text(
            controller.getMenu().value.schoolName,
            style: TextStyle(color: COLOR_BLACK, fontWeight: FontWeight.w700, fontSize: MediaQuery.of(context).size.height * 0.0195),
          )),
        ),
      ),
      drawer: SchoolDrawer(),
      body: GestureDetector(
        onVerticalDragEnd: controller.onVerticalDragEndDate,
        // 좌/우 스크롤 시 날짜 변경
        onHorizontalDragEnd: controller.onHorizontalDragEndDate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DateBar(),
            Column(
              children: [
                MenuBox(mealTimeIndex: 0),
                MenuBox(mealTimeIndex: 1),
                MenuBox(mealTimeIndex: 2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
