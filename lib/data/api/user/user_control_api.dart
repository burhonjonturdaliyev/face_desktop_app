import 'package:face_app/data/api/server/hikvision_server.dart';

class UserControlApi {
  static const String addPhoto =
      '${HikvisionServer.server}/ISAPI/Intelligent/FDLib/FaceDataRecord?format=json';
  static const String addUser =
      '${HikvisionServer.server}/ISAPI/AccessControl/UserInfo/Record?format=json';
}
