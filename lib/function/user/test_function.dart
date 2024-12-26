import 'dart:developer';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http_parser/http_parser.dart';

class DigestAuth {
  final String username;
  final String password;
  String? realm;
  String? nonce;
  String? qop;
  String? opaque;

  DigestAuth(this.username, this.password);

  String _generateCnonce() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _calculateHA1(String realm) {
    return md5.convert(utf8.encode('$username:$realm:$password')).toString();
  }

  String _calculateHA2(String method, String uri) {
    return md5.convert(utf8.encode('$method:$uri')).toString();
  }

  String generateAuthHeader(String method, String uri) {
    if (nonce == null || realm == null) return '';

    final cnonce = _generateCnonce();
    final nc = '00000001';
    final ha1 = _calculateHA1(realm!);
    final ha2 = _calculateHA2(method, uri);

    String response;
    if (qop != null) {
      response = md5
          .convert(utf8.encode('$ha1:$nonce:$nc:$cnonce:$qop:$ha2'))
          .toString();
    } else {
      response = md5.convert(utf8.encode('$ha1:$nonce:$ha2')).toString();
    }

    var header = 'Digest username="$username",'
        'realm="$realm",'
        'nonce="$nonce",'
        'uri="$uri",'
        'algorithm=MD5';

    if (qop != null) {
      header += ',qop=$qop,'
          'nc=$nc,'
          'cnonce="$cnonce"';
    }

    header += ',response="$response"';

    if (opaque != null) {
      header += ',opaque="$opaque"';
    }

    return header;
  }
}

Future<void> modifyFaceData({
  required String imagePath,
  required String fdid,
  required String fpid,
}) async {
  final username = 'admin';
  final password = 'abc@1234';
  final url = Uri.parse(
      'http://192.168.1.100/ISAPI/Intelligent/FDLib/FDModify?format=json');

  // Create digest auth instance
  final digestAuth = DigestAuth(username, password);

  // First request to get authentication parameters
  final initialResponse = await http.put(url);
  if (initialResponse.statusCode == 401) {
    final authHeader = initialResponse.headers['www-authenticate'];
    if (authHeader != null) {
      // Parse WWW-Authenticate header
      final realmMatch = RegExp(r'realm="([^"]*)"').firstMatch(authHeader);
      final nonceMatch = RegExp(r'nonce="([^"]*)"').firstMatch(authHeader);
      final qopMatch = RegExp(r'qop="?([^"]*)"?').firstMatch(authHeader);
      final opaqueMatch = RegExp(r'opaque="([^"]*)"').firstMatch(authHeader);

      digestAuth.realm = realmMatch?.group(1);
      digestAuth.nonce = nonceMatch?.group(1);
      digestAuth.qop = qopMatch?.group(1);
      digestAuth.opaque = opaqueMatch?.group(1);
    }
  }

  // Prepare the multipart request
  final request = http.MultipartRequest('PUT', url);

  // Add authorization header
  request.headers['Authorization'] =
      digestAuth.generateAuthHeader('PUT', url.toString());

  // Add JSON data
  final faceData = {
    'faceLibType': 'blackFD',
    'FDID': fdid,
    'FPID': fpid,
  };

  request.files.add(
    http.MultipartFile.fromString(
      'FaceDataRecord',
      jsonEncode(faceData),
      contentType: MediaType('application', 'json'),
    ),
  );

  // Verify file exists before proceeding
  final file = File(imagePath);
  if (!await file.exists()) {
    throw FileSystemException('File not found', imagePath);
  }

  // Add image file
  final imageStream = http.ByteStream(file.openRead());
  final imageLength = await file.length();

  request.files.add(
    http.MultipartFile(
      'FaceImage',
      imageStream,
      imageLength,
      filename: imagePath.split('/').last,
      contentType: MediaType('image', 'jpeg'),
    ),
  );

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        log('Response: $jsonResponse');
      } catch (e) {
        log('Response is not in JSON format: ${response.body}');
      }
    } else {
      log('Request failed with status: ${response.statusCode}');
      log('Error: ${response.body}');
    }
  } on SocketException catch (e) {
    log('Network error: $e');
  } catch (e) {
    log('Error during request: $e');
  }
}
