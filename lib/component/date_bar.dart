import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:poly_meal/const/mealTime.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/controller/controller.dart';

class DateBar extends StatelessWidget {
  final Controller controller = Get.find<Controller>();


  DateBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10.0, top: 30.0, left: 10, right: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          color: COLOR_GRAY,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: controller.onPressedBackDateButton,
              iconSize: MediaQuery.of(context).size.height * 0.0185,
              color: COLOR_BLACK,
              icon: Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Obx(() =>
                      TextButton(
                        onPressed: showDatePopup,
                        style : TextButton.styleFrom(
                            foregroundColor: COLOR_BLACK,
                            textStyle: TEXT_STYLE.copyWith(fontSize: MediaQuery.of(context).size.height * 0.0185),
                        ),
                        child: Text('${controller.getSelectedDate().value.year}-'
                                  '${controller.getSelectedDate().value.month}-'
                                  '${controller.getSelectedDate().value.day}'
                                  '(${WEEKDAY_MAP[controller.getSelectedDate().value.weekday]})'),
                      )
                    ),
                    SizedBox(
                      width: 0.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.105,
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: OutlinedButton(
                        onPressed: controller.onPressedTodayButton,
                        child: Text(
                          "Today",
                          style: TEXT_STYLE.copyWith(color: COLOR_ORANGE, fontSize: MediaQuery.of(context).size.height * 0.0185),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: COLOR_WHITE,
                          side: BorderSide(
                            color: COLOR_ORANGE,
                            width: 2.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
              onPressed: controller.onPressedForwardDateButton,
              iconSize: MediaQuery.of(context).size.height * 0.0185,
              color: COLOR_BLACK,
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),

      ),
    );
  }

  void showDatePopup() {
    Get.dialog(
      AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: WEEKDAY_MAP.entries.map((entry) =>
                SizedBox(
                  width: 35,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: controller.getSelectedDate().value.weekday == entry.key ? COLOR_ORANGE : COLOR_BLACK,
                      textStyle: TEXT_STYLE,
                    ),
                    child: Text(entry.value),
                    onPressed: () => closeDatePopup(entry),
                  ),
                )
            ).toList(),
          )
      ),
    );
  }

  void closeDatePopup(MapEntry<int, String> entry) {
    Get.back();

    int targetWeekday = entry.key - controller.getSelectedDate().value.weekday;
    controller.selectedDateController.plusDaySelectedDate(targetWeekday);
    controller.schoolMenuController.getMenuApi(controller.getSchoolCode().value, controller.getSelectedDate().value);
  }
}