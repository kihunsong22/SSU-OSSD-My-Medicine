import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:medicineapp/models/prescription_model.dart';

class PrescUploadScreen extends StatelessWidget {
  final int uid;
  Function func;

  PrescUploadScreen({
    super.key,
    required this.uid,
    required this.func,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.only(
            bottom: 1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10, height: 1), // for centering text
              const Text('처방전 상세정보'),
              Row(
                children: [
                  Icon(Icons.edit, color: Colors.grey[700], size: 30),
                  const SizedBox(width: 3, height: 1),
                  Icon(Icons.delete_rounded, color: Colors.grey[700], size: 30),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.grey[100],
        elevation: 5,
        shadowColor: Colors.grey[300],
      ),
      body: Container(
        padding: const EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: Colors.grey[700], size: 22),
                        const SizedBox(width: 5, height: 1),
                        const Text("prescModel.regDate",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.place_outlined,
                            color: Colors.grey[700], size: 25),
                        const SizedBox(width: 3, height: 1),
                        const Text("하나로병원",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                // const Divider(),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                // Text('처방전번호: ${prescModel.prescId.toString()}',
                //     style: const TextStyle(
                //         fontSize: 16, fontWeight: FontWeight.w500)),
                // Text('처방기간: ${prescModel.prescPeriodDays.toString()}일',
                //     style: const TextStyle(
                //         fontSize: 16, fontWeight: FontWeight.w500)),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                // const Divider(),
                // SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                Container(
                  padding:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.005),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Placeholder(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                  width: 1,
                ),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // minimumSize: const Size(300, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        backgroundColor: const Color(0xff9fa3ff)),
                    onPressed: () {
                      DisplayPopup(context);
                    },
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ), // Change this to your desired button text
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: 1,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void DisplayPopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
            bottom: 40,
          ),
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.03,
              horizontal: MediaQuery.of(context).size.width * 0.07),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: const SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: Color(0xffe66452), size: 26),
                    Text(
                      " 주의 ",
                      style: TextStyle(
                        fontSize: 26,
                        color: Color(0xffe66452),
                      ),
                    ),
                    Icon(Icons.warning_amber_rounded,
                        color: Color(0xffe66452), size: 26),
                  ],
                ),
                Column(
                  children: [
                    Text("prescModel.generatedInstruction"),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
