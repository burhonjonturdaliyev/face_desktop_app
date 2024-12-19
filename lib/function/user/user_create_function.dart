import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:face_app/data/api/server/hikvision_server.dart';
import 'package:face_app/data/const/auth/hikvision_auth_datas.dart';
import 'package:http_auth/http_auth.dart';

class UserCreateFunction {
  Future create() async {
    const uri =
        "${HikvisionServer.server}/ISAPI/AccessControl/UserInfo/Record?format=json";
    final url = Uri.parse(uri);
    final client = DigestAuthClient(
        HikvisionAuthDatas.username, HikvisionAuthDatas.password);
    DateTime now = DateTime.now();
    DateTime nextYear = DateTime(
        now.year + 1, now.month, now.day, now.hour, now.minute, now.second);
    final requestBody = {
      "UserInfo": {
        "employeeNo": "17",
        "name": "Sodiqjon",
        "userType": "normal",
        "Valid": {
          "enable": true,
          "beginTime": now.toIso8601String(),
          "endTime": nextYear.toIso8601String()
        },
        "doorRight": "1",
        "RightPlan": [
          {"doorNo": 1, "planTemplateNo": "1"}
        ]
      }
    };
    try {
      final response = await client.post(url, body: jsonEncode(requestBody));
      log(response.statusCode.toString(), name: "Response status code");
      log(response.body.toString(), name: "Response Body");
    } on SocketException {
      log("Socket Exception");
    } catch (e) {
      log(e.toString(), name: "Catch Error");
    }
  }
}
