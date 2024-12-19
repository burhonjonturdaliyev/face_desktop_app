import 'package:face_app/screens/add_user/add_user_screen.dart';
import 'package:face_app/screens/all_users/all_user_screen.dart';
import 'package:face_app/screens/example/example_screen.dart';
import 'package:face_app/screens/main/bloc/main_bloc.dart';
import 'package:face_app/util/widgets/sidebar/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainBloc(),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Row(
          children: [
            Sidebar(),
            Expanded(
              child: BlocBuilder<MainBloc, MainState>(
                builder: (context, state) {
                  if (state is MainAllUsersState) {
                    return AllUserScreen();
                  } else if (state is MainAddUserState) {
                    return AddUserScreen();
                  } else if (state is MainUserManagementState) {
                    return SizedBox();
                  } else if (state is MainExampleState) {
                    return ExampleScreen();
                  }
                  return SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
