import 'dart:developer';

class PrescListModel {
  // final uid;
  final List<dynamic> prescIdList;

  PrescListModel({
    required this.prescIdList,
  });

  int get length => prescIdList.length;

  PrescListModel.fromJson(Map<String, dynamic> json)
      // : uid = json['uid'],
      : prescIdList = json['prescIdList'];

  void printPrescId() {
    for (var i = 0; i < prescIdList.length; i++) {
      log(prescIdList[i].toString());
    }
  }
}
