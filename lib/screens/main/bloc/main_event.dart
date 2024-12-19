part of 'main_bloc.dart';

@immutable
sealed class MainEvent {}

final class MainScreenSwitchEvent extends MainEvent {
  final int index;
  MainScreenSwitchEvent({required this.index});
}