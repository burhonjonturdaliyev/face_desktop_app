import 'package:face_app/routes/routes.dart';
import 'package:face_app/screens/main/bloc/main_bloc.dart';
import 'package:face_app/util/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
          create: (context) => MainBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(context),
      darkTheme: AppTheme.darkTheme(context),
      themeMode: ThemeMode.light,
      title: 'Login Screen',
      initialRoute: RouteNames.login,
      routes: Routes.baseRoutes,
    );
  }
}
