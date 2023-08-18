import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poly_meal/const/pref_key.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/const/host.dart';
import 'package:poly_meal/const/mealTime.dart';
import 'package:poly_meal/main.dart';
import 'package:http/http.dart' as http;
import 'package:poly_meal/menu.dart';
import 'package:poly_meal/screen/select_school_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  DateTime? selectedDate;
  Map<String, String>? schoolCodeMap = {"": ""};
  String? schoolCode;

  bool menuLoading = false;
  bool schoolCodeLoading = false;
  bool isDragEnable = false;

  Menu menu = Menu.ofEmptyMenu();

  @override
  void initState() {
    selectedDate = DateTime.now();
    getSchoolListApi();
    getMenuApi();
  }

  Future<void> getMenuApi() async {
    setState(() {
      menuLoading = true;
    });

    if (schoolCode == null || schoolCode!.isEmpty) {
      await getSchoolCodeFromPref();
    }

    final url = Uri.parse("${HOST}/api/v1/menus")
        .replace(queryParameters: makeQueryParams());
    var result = await http.get(url);

    setState(() {
      menuLoading = false;
      try {
        menu = Menu.of(jsonDecode(utf8.decode(result.bodyBytes)));
      } catch (e) {
        print(e);
      }
    });
  }

  Future<void> getSchoolListApi() async {
    setState(() {
      schoolCodeLoading = true;
    });
    final url = Uri.parse("${HOST}/api/v1/schools");
    var result = await http.get(url);

    final dynamic decodedData = jsonDecode(utf8.decode(result.bodyBytes));

    final Map<String, String> schoolCodeMap = {};
    decodedData.forEach((key, value) {
      schoolCodeMap[key] = value.toString();
    });

    setState(() {
      schoolCodeLoading = false;
      this.schoolCodeMap = schoolCodeMap;
    });

    isSchoolCodeNavigator();
  }

  isSchoolCodeNavigator() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString(SCHOOLCODE) != null) {
      setState(() {
        schoolCode = pref.getString(SCHOOLCODE).toString();
      });
    } else {
      final schoolCode = await Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => SelectSchoolScreen(
                schoolCodeMap: schoolCodeMap!,
                schoolCodeLoading: schoolCodeLoading,
              )));

      setSchoolCode(schoolCode);
    }
  }

  makeQueryParams() {
    Map<String, dynamic> queryParams = {
      'schoolCode': schoolCode,
      'date': DateFormat('yyyy-MM-dd').format(selectedDate!)
    };
    return queryParams;
  }

  getSchoolCodeFromPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      schoolCode = pref.getString(SCHOOLCODE);
    });
  }

  void setSchoolCode(String schoolCode) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SCHOOLCODE, schoolCode);

    setState(() {
      this.schoolCode = schoolCode;
    });

    getMenuApi();
  }

  void onHorizontalDragEndDate(DragEndDetails details) {
    if(isDragEnable) return;

    setState(() {
      isDragEnable = true;
    });

    if (details.velocity.pixelsPerSecond.dx > 0) {
      onPressedBackDateButton();
    } else if(details.velocity.pixelsPerSecond.dx < 0) {
      onPressedForwardButton();
    }

    setState(() {
      isDragEnable = false;
    });
  }

  void onVerticalDragEndDate(DragEndDetails details) {
    if(isDragEnable) return;

    setState(() {
      isDragEnable = true;
    });

    if(details.velocity.pixelsPerSecond.dy > 0) {
      onPressedTodayButton();
    }

    setState(() {
      isDragEnable = false;
    });
  }

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
            menu.schoolName,
            style: TextStyle(color: COLOR_BLACK, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      drawer: _Drawer(
        schoolName: menu.schoolName,
        schoolCodeMap: schoolCodeMap!,
        setSchoolCode: setSchoolCode,
        schoolCodeLoading: schoolCodeLoading,
      ),
      body: GestureDetector(
        onVerticalDragEnd: onVerticalDragEndDate,
        // 좌/우 스크롤 시 날짜 변경
        onHorizontalDragEnd: onHorizontalDragEndDate,
        child: Column(
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
                        schoolCode: schoolCode ?? "",
                        menuLoading: menuLoading,
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
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
  final bool schoolCodeLoading;

  const _Drawer(
      {required this.schoolName,
      required this.schoolCodeMap,
      required this.setSchoolCode,
      required this.schoolCodeLoading,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              schoolName,
              style: TEXT_STYLE,
            ),
            accountEmail: Text(''),
            decoration: BoxDecoration(
              color: COLOR_GRAY,
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
            iconColor: COLOR_BLACK,
            title: Text(
              "학교 변경",
              style: TextStyle(color: COLOR_BLACK, fontWeight: FontWeight.w700),
            ),
            onTap: () async {
              //Drawer 메뉴 닫기
              Navigator.pop(context);
              final schoolCode =
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SelectSchoolScreen(
                            schoolCodeMap: schoolCodeMap,
                            schoolCodeLoading: schoolCodeLoading,
                          )));
              setSchoolCode(schoolCode);
            },
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
          color: COLOR_GRAY,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onPressedBackDateButton,
              iconSize: 25.0,
              color: COLOR_BLACK,
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
                          style: TEXT_STYLE.copyWith(color: COLOR_ORANGE),
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
              onPressed: onPressedForwardButton,
              iconSize: 25.0,
              color: COLOR_BLACK,
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
  final String schoolCode;
  final bool menuLoading;

  const _MenuBox({
    required this.mealTimeIndex,
    required this.menu,
    required this.schoolCode,
    required this.menuLoading,
    super.key,
  });

  String menuSplit(String menu) {
    if (schoolCode == "010") {
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
                if (menuLoading)
                  CupertinoActivityIndicator(
                    color: COLOR_ORANGE,
                    radius: 20.0,
                  ),
                if (!menuLoading)
                  SingleChildScrollView(
                    child: Text(
                      menu.isNotEmpty ?? false
                          ? menuSplit(menu!)
                          : "등록된 메뉴가 없습니다.",
                      style: TEXT_STYLE.copyWith(
                        fontSize: MediaQuery.of(context).size.height * 0.0195,
                      ),
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
