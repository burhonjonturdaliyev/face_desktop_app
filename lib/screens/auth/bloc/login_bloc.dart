import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

import '../../../function/auth/auth_function.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<AuthLoginEvent>(authLoginEvent);
  }

  FutureOr<void> authLoginEvent(
      AuthLoginEvent event, Emitter<LoginState> emit) async {
    await AuthFunction(
            emit: emit, username: event.username, password: event.password)
        .login();
  }
}
