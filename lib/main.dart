

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:poly_meal/screen/menu_screen.dart';
import 'package:poly_meal/screen/splashScreen.dart';


const Map<int, String> WEEKDAY_MAP = {
1: '월',
2: '화',
3: '수',
4: '목',
5: '금',
6: '토',
7: '일',
};

void main()  {
  return runApp(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        // home: MenuScreen(),
        home: SplashScreen(),
    ),
  );
}