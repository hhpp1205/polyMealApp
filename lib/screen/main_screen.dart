import 'package:flutter/material.dart';
import 'package:poly_meal/main.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final selectedDate = DateTime.now();

  List<String> menu = [
    '쌀밥 , 북어국 , 고등어김치조림 , 명엽채조림 , 도시락김 , 배추김치',
    '쌀밥 , 아욱된장국 , 미트볼케찹조림 , 쌈다시마/초장 , 오이무침 , 배추김치',
    '쌀밥 , 소고기미역국 , 비엔나야채볶음 , 메추리알장조림 , 깻잎지 , 배추김치',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF8400),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            "폴급식",
          ),
        ),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DateBar(
            selectedDate: selectedDate,
          ),
          Column(
            children: menu
                .map((x) => MenuBox(menu: x,)).toList(),
          ),
        ],
      ),
    );
  }
}

class _DateBar extends StatelessWidget {
  final DateTime selectedDate;
  late int year;
  late int month;
  late int day;
  late int weekday;

  _DateBar({
    required this.selectedDate,
    super.key,
  }) {
    year = selectedDate.year;
    month = selectedDate.month;
    day = selectedDate.day;
    weekday = selectedDate.weekday;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 10.0, top: 30.0, left: 10, right: 10),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.05,
        decoration: BoxDecoration(
          color: Color(0xffFF8400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Text(
            '$year-$month-$day(${WEEKDAY_MAP[weekday]})',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class MenuBox extends StatelessWidget {
  final String menu;

  const MenuBox({
    required this.menu,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.20,
        decoration: BoxDecoration(
          color: Color(0xffFF8400),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Text(
              menu,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
