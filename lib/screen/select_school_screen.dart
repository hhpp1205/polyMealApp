import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:poly_meal/const/style.dart';

class SelectSchoolScreen extends StatelessWidget {
  // Key = 학교 코드 ex) 003
  // Value = 학교 명 ex) 한국 폴리텍 대학 대전캠퍼스
  final Map<String, String> schoolCodeMap;
  final bool schoolCodeLoading;

  const SelectSchoolScreen(
      {required this.schoolCodeMap,
      required this.schoolCodeLoading,
      super.key
      });

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
            "학교를 선택해 주세요",
            style: TextStyle(color: COLOR_BLACK, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Stack(
            children: [
              Column(
                children: schoolCodeMap.entries
                    .map((entry) => TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(entry.value);
                  },
                  child: Text(
                    "${entry.key}",
                    style: TEXT_STYLE.copyWith(fontSize: MediaQuery.of(context).size.height * 0.0195),
                  ),
                ))
                    .toList(),
              ),
              if(schoolCodeLoading)
                CupertinoActivityIndicator(
                  color: COLOR_ORANGE,
                  radius: 20.0,
                ),
            ]
          ),
        ),
      ),
    );
  }
}
