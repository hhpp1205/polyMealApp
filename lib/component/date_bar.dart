import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:poly_meal/const/mealTime.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/state/selected_date_controller.dart';

class DateBar extends StatelessWidget {
  final SelectedDateController selectedDateController = Get.put(SelectedDateController());

  final VoidCallback onPressedBackDateButton;
  final VoidCallback onPressedForwardButton;
  final VoidCallback onPressedTodayButton;

  DateBar({
    required this.onPressedBackDateButton,
    required this.onPressedForwardButton,
    required this.onPressedTodayButton,
    super.key,
  })

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
              onPressed: selectedDateController.decrementSelectedDate,
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
                      Text(
                      '${selectedDateController.selectedDate.value.year}-${selectedDateController.selectedDate.value.month}-${selectedDateController.selectedDate.value.day}(${WEEKDAY_MAP[selectedDateController.selectedDate.value.weekday]})',
                      style: TEXT_STYLE.copyWith(fontSize: MediaQuery.of(context).size.height * 0.0185),
                      )
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.105,
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: OutlinedButton(
                        onPressed: selectedDateController.updateSelectedDateToToday,
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
              onPressed: selectedDateController.increaseSelectedDate,
              iconSize: MediaQuery.of(context).size.height * 0.0185,
              color: COLOR_BLACK,
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}