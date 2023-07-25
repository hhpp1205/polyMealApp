import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final selectDate = DateTime.now();
  late int year = selectDate.year;
  late int month = selectDate.month;
  late int day = selectDate.day;
  late int weekday = selectDate.weekday;

  final Map<int, String> weekdayMap = {
    1: '월',
    2: '화',
    3: '수',
    4: '목',
    5: '금',
    6: '토',
    7: '일',
  };

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '월',
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '화',
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '수',
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '목',
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '금',
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '토',
                  ),
                ),
              ),
              Flexible(
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    '일',
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
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
                  '$year-$month-$day(${weekdayMap[weekday]})',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: menu
                .map((x) => Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.height * 0.20,
                      decoration: BoxDecoration(
                        color: Color(0xffFF8400),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                            x,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}
