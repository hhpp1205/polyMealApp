import 'dart:convert';

class Menu {
  String schoolName;
  String date;
  String dayOfTheWeek;
  List<String> meal;

  Menu(this.schoolName, this.date, this.dayOfTheWeek, this.meal);

  static Menu of(Map<String, dynamic> json) {
    print("Menu call constructor");
    return Menu(
        json['schoolName'],
        json['date'],
        json['dayOfTheWeek'],
        List<String>.from(json['meal'])
    );

  }

  @override
  String toString() {
    return 'Menu{schoolName: $schoolName, date: $date, dayOfTheWeek: $dayOfTheWeek, meal: $meal}';
  }
}