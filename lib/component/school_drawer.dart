import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poly_meal/const/style.dart';
import 'package:poly_meal/controller/controller.dart';
import 'package:poly_meal/screen/select_school_screen.dart';
import 'package:poly_meal/controller/school_menu_controller.dart';
import 'package:poly_meal/controller/school_controller.dart';
import 'package:poly_meal/util/mail_sender.dart';

class SchoolDrawer extends StatelessWidget {
  final Controller controller = Get.find<Controller>();
  final SchoolMenuController schoolMenuController =
      Get.find<SchoolMenuController>();
  final SchoolController schoolController = Get.find<SchoolController>();
  final MailSender mailSender = MailSender();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              schoolMenuController.menu.value.schoolName,
              style: TEXT_STYLE.copyWith(
                  fontSize: MediaQuery.of(context).size.height * 0.013),
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
              Get.back();
              controller.schoolController.getSchoolListApi();
              final schoolCode = await Get.to(SelectSchoolScreen());
              await schoolController.setSchoolCode(schoolCode);
              controller.schoolMenuController.getMenuApi(
                  controller.getSchoolCode().value,
                  controller.getSelectedDate().value);
            },
          ),
          ListTile(
              leading: Icon(Icons.mail),
              iconColor: COLOR_BLACK,
              title: Text(
                "문의하기",
                style:
                    TextStyle(color: COLOR_BLACK, fontWeight: FontWeight.w700),
              ),
              onTap: () {
                mailSender.sendMail();
              }),
        ],
      ),
    );
  }


}
