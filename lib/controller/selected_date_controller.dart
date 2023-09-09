import 'package:get/get.dart';

class SelectedDateController extends GetxController {

   Rx<DateTime> selectedDate = DateTime.now().obs;
   RxBool isDragEnable = false.obs;

   void decrementSelectedDate() {
      selectedDate.value = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day - 1);
   }

   void increaseSelectedDate() {
      selectedDate.value = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day + 1);
   }

   void updateSelectedDateToToday() {
      selectedDate.value = DateTime.now();
   }

   void plusDaySelectedDate(int day) {
      selectedDate.value = selectedDate.value.add(Duration(days: day));
   }

}