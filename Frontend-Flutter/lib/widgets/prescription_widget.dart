import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:medicineapp/models/prescription_list_model.dart';
import 'package:medicineapp/models/prescription_model.dart';
import 'package:medicineapp/models/user_model.dart';
import 'package:medicineapp/services/api_services.dart';

// ignore: must_be_immutable
class PrescWidget extends StatelessWidget {
  final int uid, prescId;

  PrescWidget({super.key, required this.prescId, required this.uid});

  final ApiService apiService = ApiService();

  late Future<PrescModel> prescInfo = apiService.getPrescInfo(prescId);
  // late Future<Uint8List> getPrescPic = apiService.getPrescPic(prescId);
  // late Future<String> prescPicLink = apiService.getPrescPicLink(prescId);
  // late Future<String> getPrescPic = apiService.getPrescPic(prescId);
  // late Future<String> prescPic

  @override
  Widget build(BuildContext context) {
    if (prescId == -1) {
      log("prescription_widget: data is null");
      return const Placeholder();
    } else {
      log("prescription_widget: ${prescId.toString()}");
    }

    return FutureBuilder(
      future: Future.wait([
        prescInfo,
        // prescPicLink,
        // getPrescPic,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          final prescModel = snapshot.data?[0] as PrescModel;
          prescModel.printPrescInfoOneline();
          return _BuildPrescWidget(
            prescId: prescId,
            context: context,
            prescModel: prescModel,
            // prescPic: snapshot.data![1] as Uint8List,
          );
          // return _BuildPrescWidget(context, snapshot.data);
        }
      },
    );
  }
}

class _BuildPrescWidget extends StatelessWidget {
  final int prescId;
  final BuildContext context;
  final PrescModel prescModel;
  // final Uint8List prescPic;
  // final String prescPicLink;

  const _BuildPrescWidget({
    // super.key,
    required this.context,
    required this.prescModel,
    // required this.prescPic,
    required this.prescId,
  });

  String _getPrescPicLink(int prescId) {
    String url = "http://141.164.62.81:5000/getPrescPic?id=$prescId";
    log("getPrescPicLink: $url");

    return url;
  }

  @override
  Widget build(BuildContext context) {
    log("is_expired: ${prescModel.isExpired}");
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: (BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            // offset: Offset(0, 2),
            blurRadius: 6,
          ),
        ],
        color: prescModel.isExpired ? Colors.grey[350] : Colors.white,
      )),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('처방전번호: ${prescModel.id.toString()}'),
              Text(prescModel.regDate),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var i = 0; i < prescModel.medicineListLength; i++)
                    Text(
                      prescModel.medicineList[i],
                    ),
                ],
              ),
              Container(
                  width: 100,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                      color: prescModel.isExpired
                          ? Colors.grey[400]
                          : Colors.white,
                      backgroundBlendMode: BlendMode.darken,
                    ),
                    child: Image.network(
                      _getPrescPicLink(prescId),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
