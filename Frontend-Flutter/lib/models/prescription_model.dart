import 'dart:developer';

class PrescModel {
  final int prescId;
  // DateTime date;
  final String regDate;
  final int prescPeriodDays;
  final List<String> medicineList;

  PrescModel({
    required this.prescId,
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

    final year = this.regDate.substring(0, this.regDate.indexOf('-'));
    final month = this.regDate.substring(
        this.regDate.indexOf('-') + 1, this.regDate.lastIndexOf('-'));
    final day = this.regDate.substring(this.regDate.lastIndexOf('-') + 1);

    final regDate = DateTime(int.parse(year), int.parse(month), int.parse(day));

    final diff = now.difference(regDate).inDays;
    return diff > prescPeriodDays;
  }

  int get medicineListLength => medicineList.length;

  PrescModel.fromJson(Map<String, dynamic> json)
      : prescId = json['prescId'],
        regDate = json['regDate'],
        prescPeriodDays = json['duration'],
        medicineList = json['medicine'].toString().split(',').reversed.toList();

  void printPrescInfoOneline() {
    log("prescId: $prescId, date: $regDate, prescPeriodDays: $prescPeriodDays, medicineList: $medicineList");
  }
}
