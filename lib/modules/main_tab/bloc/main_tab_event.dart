import 'package:equatable/equatable.dart';

abstract class MainTabEvent extends Equatable {
  const MainTabEvent();

  @override
  List<Object?> get props => [];
}

class LoadAllTaskTabs extends MainTabEvent {}

class AddTaskTab extends MainTabEvent {
  final String tabName;
  const AddTaskTab(this.tabName);

  @override
  List<Object?> get props => [tabName];
}

class EditTaskTab extends MainTabEvent {
  final String id;
  final String tabName;
  const EditTaskTab({required this.id, required this.tabName});

  @override
  List<Object?> get props => [id, tabName];
}

class DeleteTaskTab extends MainTabEvent {
  final String id;
  const DeleteTaskTab(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangeTab extends MainTabEvent {
  final int index;
  const ChangeTab(this.index);

  @override
  List<Object?> get props => [index];
}
