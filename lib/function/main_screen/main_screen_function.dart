import 'package:bloc/bloc.dart';
import 'package:face_app/screens/main/bloc/main_bloc.dart';

class MainScreenFunction {
  static void emitState(int index, Emitter<MainState> emit) {
    switch (index) {
      case 0:
        emit(MainAllUsersState());
        break;
      case 1:
        emit(MainAddUserState());
        break;
      case 2:
        emit(MainUserManagementState());
        break;
      case 3:
        emit(MainExampleState());
        break;
      default:
        emit(MainExampleState());
    }
  }
}