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

  Future<void> postFile(File faceImageFile) async {
    const uri =
        "http://192.168.1.100/ISAPI/Intelligent/FDLib/FaceDataRecord?format=json"; // Replace with your actual API URL
    final url = Uri.parse(uri);

    // Check if the file exists and is not empty
    if (!(await faceImageFile.exists())) {
      log("File does not exist: ${faceImageFile.path}");
      return;
    }

    log(faceImageFile.path);

    final fileLength = await faceImageFile.length();
    if (fileLength == 0) {
      log("File is empty and will not be uploaded: ${faceImageFile.path}");
      return;
    }

    // Step 1: Send an unauthenticated POST request to get the nonce
    final response = await http.post(url);

    if (response.statusCode == 401) {
      final authHeader = response.headers['www-authenticate'];
      if (authHeader != null) {
        // Parse the `WWW-Authenticate` header to extract parameters
        final parts = _parseAuthenticateHeader(authHeader);

        final ha1 = _md5(
            '${HikvisionAuthDatas.username}:${parts['realm']}:${HikvisionAuthDatas.password}');
        final ha2 = _md5('POST:${parts['uri']}');
        final responseDigest = _md5('$ha1:${parts['nonce']}:$ha2');

        final authValue = 'Digest username="${HikvisionAuthDatas.username}", '
            'realm="${parts['realm']}", '
            'nonce="${parts['nonce']}", '
            'uri="${parts['uri']}", '
            'response="$responseDigest"';

        try {
          var request = http.MultipartRequest('POST', Uri.parse(uri));

          // Add the Authorization header
          request.headers['Authorization'] = authValue;

          // Add the multipart form fields
          request.fields['FaceDataRecord'] =
              jsonEncode({"faceLibType": "blackFD", "FDID": "1", "FPID": "29"});

          // Add the file
          request.files.add(await http.MultipartFile.fromPath(
              'FaceImage', faceImageFile.path));

          // Send the request
          final streamedResponse = await request.send();
          final response = await http.Response.fromStream(streamedResponse);

          if (response.statusCode == 200) {
            log('Status Code: ${response.statusCode}');
            log('Response Body: ${response.body}');
            try {
              final decodedResponse = jsonDecode(response.body);
              log('Decoded Response: $decodedResponse');
            } catch (e) {
              log('Error decoding JSON: $e');
              log('Raw Response Body: ${response.body}');
            }
          } else {
            log('Upload failed with status code: ${response.statusCode}');
            log('Response Body: ${response.body}');
          }
        } catch (e) {
          log('Error during file upload: $e');
        }
      } else {
        log('Authorization header not found in server response.');
      }
    } else {
      log('Failed to get nonce, status: ${response.statusCode}');
      log('Response body: ${response.body}');
    }
  }
}

//tetst commit 1
