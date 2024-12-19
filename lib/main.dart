import 'package:face_app/routes/routes.dart';
import 'package:face_app/util/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      title: 'Login Screen',
      initialRoute: RouteNames.example,
      routes: Routes.baseRoutes,
    );
  }
}
