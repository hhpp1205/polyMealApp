import 'dart:convert';

class Menu {
  String schoolName;
  String date;
  List<String> meal;

  Menu(this.schoolName, this.date, this.meal);

  static Menu of(Map<String, dynamic> json) {
    print("Menu call constructor");
    return Menu(
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