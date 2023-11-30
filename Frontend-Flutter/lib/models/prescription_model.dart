import 'dart:developer';

class PrescModel {
  final int id;
  // DateTime date;
  final String regDate;
  final int prescPeriodDays;
  final List<String> medicineList;

  PrescModel({
    required this.id,
    required this.regDate,
    required this.prescPeriodDays,
    required this.medicineList,
  });

  String get regDateString {
    // final year = regDate.substring(0, 4);
    // final month = regDate.substring(4, 6);
    // final day = regDate.substring(6, 8);
    // return "$year-$month-$day";
    return regDate;
  }

  PrescModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        regDate = json['regDate'],
        prescPeriodDays = json['duration'],
        medicineList = json['medicine'];

  void printPrescInfoOneline() {
    log("id: $id, date: $regDate, prescPeriodDays: $prescPeriodDays, medicineList: $medicineList");
  }
}
