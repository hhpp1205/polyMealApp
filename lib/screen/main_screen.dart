import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poly_meal/const/mealTime.dart';
import 'package:poly_meal/main.dart';
import 'package:http/http.dart' as http;
import 'package:poly_meal/menu.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DateTime? selectedDate;

  final schoolCode = "005";

  late Map<String, dynamic> queryParams = {
    'schoolCode': schoolCode,
    'date': DateFormat('yyyy-MM-dd').format(selectedDate!)
  };

  var apiResult;
  Menu menu = Menu("test", "test", "test", List.of(["", "", ""]));

  @override
  void initState() {
    selectedDate = DateTime.now();
    setApiResult();
  }

  Future<void> setApiResult() async {
    final url = Uri.parse("http://localhost:8080/api/v1/menus")
        .replace(queryParameters: makeQueryParams());
    var result = await http.get(url);
    setState(() {
      apiResult = result;
      try {
        menu = Menu.of(jsonDecode(utf8.decode(result.bodyBytes)));
      } catch (e) {
        menu.meal = List.of(["", "", ""]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFF8400),
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            menu.schoolName,
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
            selectedDate: selectedDate!,
            onPressedBackDateButton: onPressedBackDateButton,
            onPressedForwardButton: onPressedForwardButton,
            onPressedTodayButton: onPressedTodayButton,
          ),
          Column(
            children: menu.meal
                .asMap()
                .entries
                .map((x) => _MenuBox(
                      mealTimeIndex: x.key,
                      menu: x.value,
                    ))
                .toList(),
          ),
          ElevatedButton(
            onPressed: () async {
              print("decode = ${utf8.decode(apiResult.bodyBytes)}");
              print("menu = ${menu}");
              print(queryParams);
            },
            child: Text('button'),
          ),
        ],
      ),
    );
  }

  makeQueryParams() {
    Map<String, dynamic> queryParams = {
      'schoolCode': schoolCode,
      'date': DateFormat('yyyy-MM-dd').format(selectedDate!)
    };
    return queryParams;
  }

  void onPressedBackDateButton() {
    setState(() {
      selectedDate = DateTime(
          selectedDate!.year, selectedDate!.month, selectedDate!.day - 1);
    });
    setApiResult();
  }

  void onPressedForwardButton() {
    setState(() {
      selectedDate = DateTime(
          selectedDate!.year, selectedDate!.month, selectedDate!.day + 1);
    });
    setApiResult();
  }

  void onPressedTodayButton() {
    setState(() {
      selectedDate = DateTime.now();
    });
    setApiResult();
  }
}

class _DateBar extends StatelessWidget {
  final DateTime selectedDate;
  late int year;
  late int month;
  late int day;
  late int weekday;

  final VoidCallback onPressedBackDateButton;
  final VoidCallback onPressedForwardButton;
  final VoidCallback onPressedTodayButton;

  _DateBar({
    required this.selectedDate,
    required this.onPressedBackDateButton,
    required this.onPressedForwardButton,
    required this.onPressedTodayButton,
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
        child: Row(
          children: [
            IconButton(
              onPressed: onPressedBackDateButton,
              iconSize: 25.0,
              color: Colors.white,
              icon: Icon(Icons.arrow_back_ios),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$year-$month-$day(${WEEKDAY_MAP[weekday]})',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    SizedBox(
                      width: 80.0,
                      child: OutlinedButton(
                        onPressed: onPressedTodayButton,
                        child: Text(
                          "Today",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(
                            color: Colors.white,
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
              onPressed: onPressedForwardButton,
              iconSize: 25.0,
              color: Colors.white,
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuBox extends StatelessWidget {
  final int mealTimeIndex;
  final String menu;

  const _MenuBox({
    required this.mealTimeIndex,
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
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.height * 0.03,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    // color: Colors.white,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        MEAL_TIME[mealTimeIndex],
                        style: TextStyle(
                            color: Color(0xffFF8400),
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                Text(
                  menu.isNotEmpty ?? false ? menu! : "등록된 메뉴가 없습니다.",
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
