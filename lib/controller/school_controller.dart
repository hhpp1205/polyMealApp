import 'dart:convert';

import 'package:get/get.dart';
import 'package:poly_meal/const/host.dart';
import 'package:poly_meal/const/pref_key.dart';
import 'package:poly_meal/controller/school_menu_controller.dart';
import 'package:poly_meal/screen/select_school_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SchoolController extends GetxController{
  SchoolMenuController schoolMenuController = Get.put(SchoolMenuController());

  Rx<String> schoolCode = "".obs;
  RxMap<String, String> schoolCodeMap = {"": ""}.obs;
  RxBool schoolMapLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getSchoolCodeFromPref();
    isSchoolCodeNavigator();
  }

  getSchoolCodeFromPref() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    schoolCode.value = pref.getString(SCHOOLCODE) ?? "";
  }

  setSchoolCode(String schoolCode) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(SCHOOLCODE, schoolCode);

    this.schoolCode.value = schoolCode;
  }

  isSchoolCodeNavigator() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString(SCHOOLCODE) != null) {
       schoolCode.value = await pref.getString(SCHOOLCODE).toString();
    }else {
      await getSchoolListApi();
      final schoolCode = await Get.to(() => SelectSchoolScreen());
      await setSchoolCode(schoolCode);
    }
  }

  Future<void> getSchoolListApi() async {
    schoolMapLoading.value = true;

    final url = Uri.parse("${HOST}/api/v1/schools");
    var result = await http.get(url);

    final dynamic decodedData = jsonDecode(utf8.decode(result.bodyBytes));

    final Map<String, String> schoolCodeMap = {};
    decodedData.forEach((key, value) {
      schoolCodeMap[key] = value.toString();
    });

    schoolMapLoading.value = false;
    this.schoolCodeMap.value = schoolCodeMap;
  }

}