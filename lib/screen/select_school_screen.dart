import 'package:flutter/material.dart';

class SelectSchoolScreen extends StatelessWidget {
  // Key = 학교 코드 ex) 003
  // Value = 학교 명 ex) 한국 폴리텍 대학 대전캠퍼스
  final Map<String, String> schoolCodeMap;

  const SelectSchoolScreen(
      {required this.schoolCodeMap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: schoolCodeMap.entries
              .map((entry) => TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(entry.key);
                    },
                    child: Text("${entry.value}"),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
