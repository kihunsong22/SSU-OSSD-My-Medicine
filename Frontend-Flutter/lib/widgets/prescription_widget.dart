import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medicineapp/models/prescription_list_model.dart';
import 'package:medicineapp/models/user_model.dart';

class PrescWidget extends StatelessWidget {
  // final Object data;
  // final UserModel data;
  // final PrescModel data;
  final int data;

  const PrescWidget({super.key, required this.data});
  // final UserModel user = UserModel.fromJson(jsonDecode(data.toString()));

  @override
  Widget build(BuildContext context) {
    if (data == -1) {
      log("prescription_widget: data is null");
      return const Placeholder();
    } else {
      log("prescription_widget: ${data.toString()}");
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: (BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.red[50],
        color: Colors.white,
      )),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("처방전이름"),
              Text("처방전날짜"),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                children: [
                  Text("약이름"),
                  Text("약이름"),
                  Text("약이름"),
                  Text("약이름"),
                  Text("약이름"),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[500],
                ),
                child: const SizedBox(
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
