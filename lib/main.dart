
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_meal/screen/menu_screen.dart';
import 'package:flutter/services.dart';



void main()  {
  //세로 모드 고정
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  return runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MenuScreen(),
    ),
  );
}