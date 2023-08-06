import 'package:flutter/material.dart';
import 'package:poly_meal/screen/main_screen.dart';

const Map<int, String> WEEKDAY_MAP = {
1: '월',
2: '화',
3: '수',
4: '목',
5: '금',
6: '토',
7: '일',
};

void main() {
  return runApp(
      MaterialApp(
        home: MainScreen(),
    ),
  );
}