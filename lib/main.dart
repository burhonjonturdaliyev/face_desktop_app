import 'package:face_app/routes/routes.dart';
import 'package:face_app/screens/auth/bloc/login_bloc.dart';
import 'package:face_app/screens/main/bloc/main_bloc.dart';
import 'package:face_app/util/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  final screenSize = await windowManager.getSize();
  WindowOptions windowOptions = WindowOptions(
    size: screenSize,
    minimumSize: const Size(800, 700),
    center: true,
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<MainBloc>(
          create: (context) => MainBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(context),
        darkTheme: AppTheme.darkTheme(context),
        themeMode: ThemeMode.light,
        title: 'Login Screen',
        initialRoute: RouteNames.login,
        routes: Routes.baseRoutes,
      ),
    );
  }
}


//test commit 1