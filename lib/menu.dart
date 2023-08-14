import 'dart:convert';

class Menu {
  String schoolCode;
  String schoolName;
  String date;
  List<String> meal;

  Menu(this.schoolCode, this.schoolName, this.date, this.meal);

  static Menu of(Map<String, dynamic> json) {
    return Menu(
        json['schoolCode'],
        json['schoolName'],
        json['date'],
        List<String>.from(json['meal'])
    );

  }

  @override
  String toString() {
    return 'Menu{schoolName: $schoolName, date: $date, meal: $meal}';
  }
}