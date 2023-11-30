import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:medicineapp/models/prescription_list_model.dart';
import 'package:medicineapp/models/prescription_model.dart';
import 'package:medicineapp/models/user_model.dart';

class ApiService {
  static const String baseUrl = '141.164.62.81:5000';

  Future<int> pingServer() async {
    final url = Uri.http(baseUrl, '/ping');
    final response = await http.get(url);
    log("/ping: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode != 204) {
      log('Server Response : ${response.statusCode}');
    }
    return response.statusCode;
  }

  Future<UserModel> getUserInfo(String uid) async {
    final url = Uri.http(baseUrl, '/getUserInfo', {'uid': uid});
    log(url.toString());
    final response = await http.get(url);
    log("/getUserInfo: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);
      log(resData.toString());

      final userData = UserModel.fromJson(resData);
      return userData;
    }
    throw Error();
  }

// get list of prescriptions
  Future<PrescListModel> getPrescList(String uid) async {
    final url = Uri.http(baseUrl, '/getPrescList', {'uid': uid});
    final response = await http.get(url);
    log("/getPrescList: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);

      final prescData = PrescListModel.fromJson(resData);
      return prescData;
    }
    throw Error();
  }

// get detailed information of a prescription
  Future<PrescModel> getPrescInfo(String prescId) async {
    final url = Uri.http(baseUrl, '/getPrescInfo', {'id': prescId});
    final response = await http.get(url);
    log("/getPrescInfo: <${response.statusCode}>, <${response.body}>");
    if (response.statusCode == 200) {
      final resData = jsonDecode(response.body);

      final prescData = PrescModel.fromJson(resData);
      return prescData;
    }
    throw Error();
  }
}
