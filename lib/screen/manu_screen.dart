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

class ManuScreen extends StatefulWidget {
  const ManuScreen({super.key});

  @override
  State<ManuScreen> createState() => _ManuScreenState();
}

class _ManuScreenState extends State<ManuScreen> {
  DateTime? selectedDate;
  Map<String, String>? schoolCodeMap = {"": ""};
  String? schoolCode;

  bool loading = false;

  Menu menu = Menu("학교를 선택해 주세요", "", "", List.of(["", "", ""]));

  @override
  void initState() {
    selectedDate = DateTime.now();
    isSchoolCodeNavigator();
    getMenuApi();
    getSchoolListApi();
  }

  Future<void> getMenuApi() async {
    setState(() {
      loading = true;
    });

    if(schoolCode == null || schoolCode!.isEmpty) {
      await getSchoolCodeFromPref();
    }

    final url = Uri.parse("${HOST}/api/v1/menus")
        .replace(queryParameters: makeQueryParams());
    var result = await http.get(url);

    setState(() {
      loading = false;
      try {
        menu = Menu.of(jsonDecode(utf8.decode(result.bodyBytes)));
      } catch (e) {
        menu.meal = List.of(["", "", ""]);
      }
    });
  }

  Future<void> getSchoolListApi() async {
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

  isSchoolCodeNavigator() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if(pref.getString(SCHOOLCODE) != null) {
      setState(() {
        schoolCode = pref.getString(SCHOOLCODE).toString();
      });
    } else {
      final schoolCode = await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => SelectSchoolScreen(schoolCodeMap: schoolCodeMap!))
      );

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

  getSchoolCodeFromPref() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    setState(()  {
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
      ),
      body: GestureDetector(
        // 위에서 아래로 드래그 시 오늘 날짜로 업데이트
        onVerticalDragUpdate: (details) {
          if (details.delta.dy > 110) {
            onPressedTodayButton();
          }
        },
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
                        loading: loading,
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
  final bool loading;

  const _MenuBox({
    required this.mealTimeIndex,
    required this.menu,
    required this.schoolCode,
    required this.loading,
    super.key,
  });

  String menuSplit(String menu) {
    if(schoolCode == "010") {
      return menu;
    }

    if(menu.indexOf(",") == - 1) {
      return menu;
    }
    List<String> splitMenu = menu.split(", ");

    String resultMenu = "";

    for(int i = 0; i < splitMenu.length - 1; i += 2) {
      if(i > splitMenu.length) {
        resultMenu += splitMenu[i - 1];
        continue;
      }
      resultMenu += "${splitMenu[i]}, ${splitMenu[i+1]} \n";
    }

    return resultMenu;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.215,
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
                        style: TEXT_STYLE.copyWith(color: COLOR_WHITE),
                      ),
                    ),
                  ),
                ),
                if(loading) CupertinoActivityIndicator(
                    color: COLOR_ORANGE,
                    radius: 20.0,
                ),
                if(!loading)
                SingleChildScrollView(
                  child: Text(
                    menu.isNotEmpty ?? false ? menuSplit(menu!) : "등록된 메뉴가 없습니다.",
                    style: TEXT_STYLE.copyWith(fontSize: 17.0),
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
