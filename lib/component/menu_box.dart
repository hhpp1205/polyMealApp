import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:poly_meal/const/mealTime.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/controller/controller.dart';
import 'package:poly_meal/controller/school_menu_controller.dart';
import 'package:poly_meal/controller/school_controller.dart';

class MenuBox extends StatelessWidget {
  final Controller controller = Get.find<Controller>();

  final int mealTimeIndex;

  MenuBox({required this.mealTimeIndex, super.key});

  String menuSplit(String menu) {
    if (controller.getSchoolCode().value == "010") {
      return menu;
    }

    if (menu.indexOf(",") == -1) {
      return menu;
    }
    List<String> splitMenu = menu.split(", ");

    String resultMenu = "";

    for (int i = 0; i < splitMenu.length - 1; i += 2) {
      if (i > splitMenu.length) {
        resultMenu += splitMenu[i - 1];
        continue;
      }
      resultMenu += "${splitMenu[i]}, ${splitMenu[i + 1]} \n";
    }

    return resultMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.235,
        decoration: BoxDecoration(
          color: COLOR_WHITE,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.03,
                    decoration: BoxDecoration(
                      color: COLOR_ORANGE,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        MEAL_TIME[mealTimeIndex],
                        style: TEXT_STYLE.copyWith(
                          color: COLOR_WHITE,
                          fontSize: MediaQuery.of(context).size.height * 0.0195,
                        ),
                      ),
                    ),
                  ),
                ),
                  Obx(() {
                    if (controller.getIsMenuLoading().value){
                      return CupertinoActivityIndicator(
                        color: COLOR_ORANGE,
                        radius: 20.0,
                      );
                    }else {
                      return Obx(() => Text(
                          controller.schoolMenuController.isMealEmpty()
                              ? "등록된 메뉴가 없습니다."
                              : menuSplit(controller.getMenu().value.meal[mealTimeIndex]),
                          style: TEXT_STYLE.copyWith(
                            fontSize: MediaQuery.of(context).size.height * 0.018,
                          ),
                        ));
                    }
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
