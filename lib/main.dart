
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_meal/screen/menu_screen.dart';



void main()  {
  return runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: MenuScreen(),
    ),
  );
}