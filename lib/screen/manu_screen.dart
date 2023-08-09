import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/const/host.dart';
import 'package:poly_meal/const/mealTime.dart';
import 'package:poly_meal/main.dart';
import 'package:http/http.dart' as http;
import 'package:poly_meal/menu.dart';
import 'package:poly_meal/screen/select_school_screen.dart';

class ManuScreen extends StatefulWidget {
  const ManuScreen({super.key});

  @override
  State<ManuScreen> createState() => _ManuScreenState();
}

class _ManuScreenState extends State<ManuScreen> {
  DateTime? selectedDate;
  Map<String, String>? schoolCodeMap = {"001": "대전폴리텍", "002": "서울정수폴리택"};
  String schoolCode = "006";

  late Map<String, dynamic> queryParams = {
    'schoolCode': schoolCode,
    'date': DateFormat('yyyy-MM-dd').format(selectedDate!)
  };

  Menu menu = Menu("test", "test", "test", List.of(["", "", ""]));

  @override
  void initState() {
    selectedDate = DateTime.now();
    getMenuApi();
    getSchoolApi();
  }

  Future<void> getMenuApi() async {
    final url = Uri.parse("${HOST}/api/v1/menus")
        .replace(queryParameters: makeQueryParams());
    var result = await http.get(url);
    setState(() {
      try {
        menu = Menu.of(jsonDecode(utf8.decode(result.bodyBytes)));
      } catch (e) {
        menu.meal = List.of(["", "", ""]);
      }
    });
  }

  Future<void> getSchoolApi() async {
    final url = Uri.parse("${HOST}/api/v1/schools");
    var result = await http.get(url);

    final dynamic decodedData = jsonDecode(utf8.decode(result.bodyBytes));

    final Map<String, String> schoolCodeMap = {};
    decodedData.forEach((key, value) {
      schoolCodeMap[key] = value.toString();
    });

    setState(() {
      this.schoolCodeMap = schoolCodeMap;
    });
  }

  void setSchoolCode(String schoolCode) {
    setState(() {
      this.schoolCode = schoolCode;
    });

    getMenuApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_IVORY,
      appBar: AppBar(
        backgroundColor: COLOR_NAVY,
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(
            menu.schoolName,
            style: TextStyle(color: COLOR_IVORY, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      drawer: _Drawer(
        schoolName: menu.schoolName,
        schoolCodeMap: schoolCodeMap!,
        setSchoolCode: setSchoolCode,
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
              print("menu = ${menu}");
              print(queryParams);
              print(schoolCodeMap);
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
    getMenuApi();
  }

  void onPressedForwardButton() {
    setState(() {
      selectedDate = DateTime(
          selectedDate!.year, selectedDate!.month, selectedDate!.day + 1);
    });
    getMenuApi();
  }

  void onPressedTodayButton() {
    setState(() {
      selectedDate = DateTime.now();
    });
    getMenuApi();
  }
}

class _Drawer extends StatelessWidget {
  final String schoolName;
  final Map<String, String> schoolCodeMap;
  final setSchoolCode;

  const _Drawer(
      {required this.schoolName,
      required this.schoolCodeMap,
      required this.setSchoolCode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              schoolName,
              style: TextStyle(
                color: COLOR_IVORY,
                fontWeight: FontWeight.w700,
              ),
            ),
            accountEmail: Text(''),
            decoration: BoxDecoration(
              color: COLOR_NAVY,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10.0),
                bottomRight: Radius.circular(10.0),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.school,
            ),
            iconColor: COLOR_NAVY,
            title: Text(
              "학교 변경",
              style: TextStyle(color: COLOR_NAVY, fontWeight: FontWeight.w700),
            ),
            onTap: () async {
              //Drawer 메뉴 닫기
              Navigator.pop(context);
              final schoolCode = await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SelectSchoolScreen(
                            schoolCodeMap: schoolCodeMap,
                          )));
              setSchoolCode(schoolCode);
            },
          )
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
          color: COLOR_NAVY,
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
                      style: TEXT_STYLE,
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
                          style: TEXT_STYLE,
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: COLOR_IVORY,
                          side: BorderSide(
                            color: COLOR_IVORY,
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
              color: COLOR_IVORY,
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
          color: COLOR_NAVY,
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
                      color: COLOR_IVORY,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        MEAL_TIME[mealTimeIndex],
                        style: TEXT_STYLE.copyWith(color: COLOR_NAVY),
                      ),
                    ),
                  ),
                ),
                Text(
                  menu.isNotEmpty ?? false ? menu! : "등록된 메뉴가 없습니다.",
                  style: TEXT_STYLE.copyWith(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
