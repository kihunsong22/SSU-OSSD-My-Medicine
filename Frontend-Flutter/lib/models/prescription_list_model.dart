import 'dart:developer';

class PrescListModel {
  // final uid;
  final List<dynamic> prescId;

  PrescListModel({
    required this.prescId,
  });

  int get length => prescId.length;

  PrescListModel.fromJson(Map<String, dynamic> json)
      // : uid = json['uid'],
      : prescId = json['prescId'];

  void printPrescId() {
    for (var i = 0; i < prescId.length; i++) {
      log(prescId[i].toString());
    }
  }
}
