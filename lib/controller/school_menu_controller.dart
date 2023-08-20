import 'dart:convert';

import 'package:get/get.dart';
import 'package:poly_meal/const/host.dart';
import 'package:poly_meal/model/menu.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SchoolMenuController extends GetxController{
  Rx<Menu> menu = Menu.ofEmptyMenu().obs;
  RxBool isMenuLoading = false.obs;


  Future<void> getMenuApi(String schoolCode, DateTime date) async {
    isMenuLoading.value = true;

    // if (schoolCode == null || schoolCode!.isEmpty) {
    //   await getSchoolCodeFromPref();
    // }
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);

    Map<String, dynamic> queryParam = new Map();
    queryParam["schoolCode"] = schoolCode;
    queryParam["date"] = formattedDate;

    final url = Uri.parse("${HOST}/api/v1/menus")
        .replace(queryParameters: queryParam);
    var result = await http.get(url);

    isMenuLoading.value = false;
    try {
      menu.value = await Menu.of(jsonDecode(utf8.decode(result.bodyBytes)));
      print("menu = ${menu}");
    } catch (e) {
      print(e);
    }
  }

  isMealEmpty() {
    if((menu.value.meal[0] == "" && menu.value.meal[1] == "" && menu.value.meal[2] == "") || menu == null) {
      return true;
    }
    return false;
  }

}