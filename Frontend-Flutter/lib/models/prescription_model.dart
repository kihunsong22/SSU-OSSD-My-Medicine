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

  bool get isExpired {
    final now = DateTime.now();
    final regDate = DateTime.parse(this.regDate);
    final diff = now.difference(regDate).inDays;
    return diff > prescPeriodDays;
  }

  int get medicineListLength => medicineList.length;

  PrescModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        regDate = json['regDate'],
        prescPeriodDays = json['duration'],
        medicineList = json['medicine'].toString().split(',').reversed.toList();

  void printPrescInfoOneline() {
    log("id: $id, date: $regDate, prescPeriodDays: $prescPeriodDays, medicineList: $medicineList");
  }
}
