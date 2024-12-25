import 'package:face_app/util/widgets/snacbar/scaffold_messanger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../util/widgets/fields/custom_text_field.dart';
import 'bloc/login_bloc.dart';

class LoginScreen extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Container(
            constraints: BoxConstraints(maxWidth: 450),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  spreadRadius: 3,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hikvision',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
                SizedBox(height: 20),
                BlocListener<LoginBloc, LoginState>(
                  listener: (context, state) {
                    if (state is LoginSuccessState) {
                      ScaffoldMessengerUtil.showSuccessSnackBar(
                          context, 'Successfully logged');
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/main',
                            (Route<dynamic> route) => false,
                      );
                    } else if (state is LoginErrorState) {
                      ScaffoldMessengerUtil.showErrorSnackBar(
                          context,
                          state.message
                      );
                    }
                  },
                  child: Form(
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: _usernameController,
                          label: 'Username',
                          icon: Icons.person,
                        ),
                        SizedBox(height: 15),
                        CustomTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            context.read<LoginBloc>().add(
                              AuthLoginEvent(
                                username: _usernameController,
                                password: _passwordController,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: theme.textTheme.labelLarge?.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
