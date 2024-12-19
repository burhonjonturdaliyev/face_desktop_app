import 'package:face_app/screens/auth/login_screen.dart';
import 'package:face_app/screens/example/example_screen.dart';
import 'package:face_app/screens/main/main_screen.dart';
import 'package:flutter/material.dart';

class RouteNames {
  static const String login = '/';
  static const String main = '/main';
  static const String example = '/example';
}

class Routes {
  static final Map<String, WidgetBuilder> baseRoutes = {
    RouteNames.login: (context) => LoginScreen(),
    RouteNames.main: (context) => MainScreen(),
    RouteNames.example: (context) => ExampleScreen(),
  };
}