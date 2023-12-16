import 'dart:developer';
import 'dart:io';
// import 'dart:math' as math;
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medicineapp/models/prescription_model.dart';
import 'package:medicineapp/screens/login_screen.dart';
import 'package:medicineapp/screens/presc_list_screen.dart';
import 'package:medicineapp/services/api_services.dart';
import 'package:medicineapp/widgets/toast.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class PrescUploadScreen extends StatefulWidget {
  final int uid;
  Function func;

  PrescUploadScreen({
    super.key,
    required this.uid,
    required this.func,
  });

  final ApiService apiService = ApiService();

  @override
  State<PrescUploadScreen> createState() => _PrescUploadScreenState();
}

class _PrescUploadScreenState extends State<PrescUploadScreen> {
  final List<TextEditingController> _controllers = [];
  final _prescDaysController = TextEditingController();

  XFile? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      _controllers.add(TextEditingController());
    }
  }

  void _addTile() {
    setState(() {
      _controllers.add(TextEditingController());
    });
  }

  void _removeTile(int index) {
    setState(() {
      // _controllers.removeLast();
      _controllers.removeAt(index - 1);
    });
  }

  String _fetchMedicineList() {
    String medicineList = "";
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        continue;
      } else {
        if (i > 0) {
          medicineList += ", ";
        }
        medicineList += _controllers[i].text;
      }
    }
    log("/presc_upload_screen: medicineList: $medicineList");
    return medicineList;
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _image = pickedFile;
    });
  }

  void validateAndSubmit(BuildContext context) async {
    String medicineList = _fetchMedicineList();
    if (_prescDaysController.text.isEmpty) {
      showToast("복용일수를 입력해주세요");
      return;
    }

    if (medicineList.isEmpty) {
      showToast("약을 입력해주세요");
      return;
    } else {
      // log("/presc_upload_screen: validateAndSubmit(): length: ${_controllers.length}");
    }

    if (_image == null) {
      showToast("처방전 사진을 추가해주세요");
      return;
    }
    int duration = int.parse(_prescDaysController.text);

    final uploadResult =
        await _uploadPresc(widget.uid, duration, medicineList, _image!);

    log("/presc_upload_screen: validateAndSubmit(): uploadResult: $uploadResult");

    if (uploadResult == 200) {
      showToast("처방전이 등록되었습니다.");
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => PrescListScreen(uid: this.uid, func: this.func)),
      //   // (Route<dynamic> route) => false,
      // );

      widget.func(context);

      // PersistentNavBarNavigator.pushNewScreen(
      //   context,
      //   screen: PrescListScreen(uid: widget.uid, func: widget.func),
      // );
    } else {
      showToast("처방전 등록 에러");
    }
  }

  Future<int> _uploadPresc(
      int uid, int duration, String medList, XFile img) async {
    final imgBytes = await img.readAsBytes();
    int uploadResult =
        await widget.apiService.uploadImage(uid, duration, medList, imgBytes);
    log("/presc_upload_screen: _uploadPresc(): uploadResult: $uploadResult");

    return uploadResult;
  }

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
              IconButton(
                onPressed: () => {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PrescListScreen(uid: widget.uid, func: widget.func),
                  )
                },
                // icon: Icon(Icons.arrow_back_ios, color: Colors.grey[600]),
                icon: Icon(Icons.arrow_back_sharp, color: Colors.grey[600]),
              ),
              const Text('처방전 업로드'),
              const SizedBox(width: 30, height: 1), // for centering text
            ],
          ),
        ),
        // backgroundColor: Colors.grey[100],
        backgroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey[300],
      ),
      body: Container(
        color: const Color(0xfff2f2ff),
        padding: const EdgeInsets.only(
          top: 25,
          left: 25,
          right: 25,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            color: Colors.grey[900], size: 25),
                        const SizedBox(width: 10, height: 1),
                        const Text("복용일수: ",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 30,
                          height: 30,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: _prescDaysController,
                            textAlign: TextAlign.center,
                            textAlignVertical: TextAlignVertical.bottom,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: '7',
                              hintStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[400],
                              ),
                              contentPadding: const EdgeInsets.only(bottom: 4),
                            ),
                          ),
                        ),
                        const Text("일",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.place_outlined,
                            color: Colors.grey[900], size: 25),
                        const SizedBox(width: 3, height: 1),
                        const Text("하나로병원",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                  width: 1,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.01,
                    bottom: MediaQuery.of(context).size.height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: _controllers.length,
                          itemBuilder: (context, index) {
                            return MedInfoTile(
                              idx: index + 1,
                              controller: _controllers[index],
                              onRemove: _removeTile,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: _addTile,
                            child: Row(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Colors.grey[600], size: 30),
                                const SizedBox(width: 4),
                                Text(
                                  "약 추가",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                  width: 1,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.22,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (_image != null)
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_image!.path),
                                // height: 150,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo_outlined,
                                    color: Colors.grey[600], size: 30),
                                const SizedBox(height: 4),
                                Text(
                                  "처방전 사진 추가",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        // backgroundColor: const Color(0xff9fa3ff)),
                        backgroundColor: Colors.deepPurple[300]),
                    onPressed: () {
                      validateAndSubmit(context);
                    },
                    child: const Text(
                      '저장',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 45),
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

class MedInfoTile extends StatelessWidget {
  final int idx;
  final TextEditingController controller;
  Function onRemove;

  MedInfoTile({
    super.key,
    required this.idx,
    required this.controller,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.04,
        // right: MediaQuery.of(context).size.width * 0.05,
      ),
      visualDensity: VisualDensity.compact,
      minVerticalPadding: 5,
      horizontalTitleGap: 0,
      minLeadingWidth: 0,
      leading: Container(
        width: 40,
        height: 40,
        margin: const EdgeInsets.only(right: 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[200],
        ),
        child: Center(
          child: Text(
            "$idx",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 220,
            height: 30,
            alignment: Alignment.bottomCenter,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.bottom,
              maxLines: 1,
              decoration: InputDecoration(
                isDense: true,
                hintText: '아스피린',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[400],
                ),
                contentPadding: const EdgeInsets.only(bottom: 4),
              ),
            ),
          ),
          const SizedBox(
            width: 3,
          ),
          IconButton(
            onPressed: () => {
              onRemove(idx),
            },
            icon: Icon(
              Icons.delete_outline,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
      // trailing:
    );
  }
}
