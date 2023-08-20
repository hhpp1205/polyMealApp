import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/controller/school_controller.dart';

class SelectSchoolScreen extends StatelessWidget {
  final SchoolController schoolController = Get.put(SchoolController());

  SelectSchoolScreen({super.key});

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
          child: Text(
            "학교를 선택해 주세요",
            style: TextStyle(color: COLOR_BLACK, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Obx(() {
                if(schoolController.schoolMapLoading.value) {
                  print(schoolController.schoolMapLoading);
                  return CupertinoActivityIndicator(
                    color: COLOR_ORANGE,
                    radius: 20.0,
                  );
                } else {
                  return Column(
                    children: schoolController.schoolCodeMap.entries
                        .map((entry) => TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(entry.value);
                      },
                      child: Text(
                        "${entry.key}",
                        style: TEXT_STYLE.copyWith(fontSize: MediaQuery.of(context).size.height * 0.0195),
                      ),
                    )).toList(),
                  );
                }
              }),
            ]
          ),
        ),
      ),
    );
  }
}
