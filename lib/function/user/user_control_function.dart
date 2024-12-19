import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:http_auth/http_auth.dart';

import 'package:face_app/data/api/user/user_control_api.dart';
import 'package:face_app/data/const/auth/hikvision_auth_datas.dart';
// To handle file paths

class UserControlFunction {
  Future create() async {
    const uri = UserControlApi.addUser;
    final url = Uri.parse(uri);
    final client = DigestAuthClient(
        HikvisionAuthDatas.username, HikvisionAuthDatas.password);

    final requestBody = {
      "UserInfo": {
        "employeeNo": "21",
        "name": "Sodiqjon",
        "userType": "normal",
        "Valid": {
          "enable": true,
          "beginTime": "2024-10-01T17:30:08",
          "endTime": "2025-10-01T17:30:08"
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

  String _md5(String input) {
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  Map<String, String> _parseAuthenticateHeader(String header) {
    final regex = RegExp(r'(\w+)="([^"]+)"');
    final matches = regex.allMatches(header);
    final Map<String, String> params = {};
    for (final match in matches) {
      params[match.group(1)!] = match.group(2)!;
    }
    return params;
  }

  Future postFile(File faceImageFile) async {
    const uri = UserControlApi.addPhoto;
    final url = Uri.parse(uri);

    // Check if the file exists and is not empty
    if (!(await faceImageFile.exists())) {
      print("File does not exist: ${faceImageFile.path}");
      return;
    }

    final fileLength = await faceImageFile.length();
    if (fileLength == 0) {
      print("File is empty and will not be uploaded: ${faceImageFile.path}");
      return;
    }

    // Step 1: Send an unauthenticated POST request to get the nonce
    final response = await http.post(url);

    if (response.statusCode == 401) {
      final authHeader = response.headers['www-authenticate'];
      if (authHeader != null) {
        // Step 2: Parse the `WWW-Authenticate` header to extract parameters
        final parts = _parseAuthenticateHeader(authHeader);

        // Step 3: Generate the Digest Authentication header
        final ha1 = _md5(
            '${HikvisionAuthDatas.username}:${parts['realm']}:${HikvisionAuthDatas.password}');
        final ha2 = _md5('POST:${parts['uri']}');
        final responseDigest = _md5('$ha1:${parts['nonce']}:$ha2');

        final authValue = 'Digest username="${HikvisionAuthDatas.username}", '
            'realm="${parts['realm']}", '
            'nonce="${parts['nonce']}", '
            'uri="${parts['uri']}", '
            'response="$responseDigest"';

        // Step 4: Prepare multipart request to send form data and file
        final request = http.MultipartRequest('POST', url)
          ..headers['Authorization'] = authValue
          ..fields['FaceDataRecord'] =
              jsonEncode({"faceLibType": "blackFD", "FDID": "1", "FPID": "21"})
          ..files.add(
            await http.MultipartFile.fromPath(
              'FaceImage',
              faceImageFile.path,
            ),
          );

        // Step 5: Send the authenticated request with form data and file
        final authenticatedResponse = await request.send();

        log(authenticatedResponse.statusCode.toString(),
            name: "Response status code");

        if (authenticatedResponse.statusCode == 200) {
          final responseBody =
              await authenticatedResponse.stream.bytesToString();
          print('Authenticated response: $responseBody');
        } else {
          final responseBody =
              await authenticatedResponse.stream.bytesToString();
          print('Authentication failed: ${authenticatedResponse.statusCode}');
          print('Authenticated response: $responseBody');
        }
      }
    } else {
      print('Failed to get nonce, status: ${response.statusCode}');
    }
  }
}
