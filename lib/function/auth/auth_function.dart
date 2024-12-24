import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../screens/auth/bloc/login_bloc.dart';

class AuthFunction {
  final Emitter<LoginState> emit;
  final TextEditingController username;
  final TextEditingController password;

  AuthFunction({
    required this.emit,
    required this.username,
    required this.password,
  });

  Future<void> login() async {
    if (username.text.isEmpty || password.text.isEmpty) {
      emit(LoginErrorState(message: 'Username va password bo\'sh bo\'lmasligi kerak.'));
      return;
    }

    emit(LoginLoadingState());

    try {

      if (username.text == '1' && password.text == '1') {
        emit(LoginSuccessState());
      } else {
        emit(LoginErrorState(message: 'Invalid username or password.'));
      }
    } catch (e) {
      emit(LoginErrorState(message: 'Exception: $e'));
    }
  }
}
