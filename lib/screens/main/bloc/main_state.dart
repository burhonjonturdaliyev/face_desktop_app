part of 'main_bloc.dart';

@immutable
sealed class MainState {}

final class MainInitial extends MainState {}

final class MainAllUsersState extends MainState {}

final class MainAddUserState extends MainState {}

final class MainUserManagement extends MainState {}
