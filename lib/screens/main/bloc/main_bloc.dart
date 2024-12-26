import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../../function/main_screen/main_screen_function.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(MainInitial()) {
    on<MainScreenSwitchEvent>(onSwitch);
  }
  void onSwitch(MainScreenSwitchEvent event, Emitter<MainState> emit) {
    MainScreenFunction.emitState(event.index, emit);
  }
}
