import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:uuid/uuid.dart';
import 'package:jaku/data/models/task_tab.dart';
import 'package:jaku/services/task_tab_service.dart';
import 'main_tab_event.dart';
import 'main_tab_state.dart';

class MainTabBloc extends Bloc<MainTabEvent, MainTabState> {
  final PersistentTabController mainTabController =
      PersistentTabController(initialIndex: 0);
  final Uuid uuid = const Uuid();

  MainTabBloc() : super(const MainTabState()) {
    on<LoadAllTaskTabs>(_onLoadAllTaskTabs);
    on<AddTaskTab>(_onAddTaskTab);
    on<EditTaskTab>(_onEditTaskTab);
    on<DeleteTaskTab>(_onDeleteTaskTab);
    on<ChangeTab>(_onChangeTab);

    mainTabController.addListener(() {
      if (mainTabController.index != state.currentIndex) {
        add(ChangeTab(mainTabController.index));
      }
    });
  }

  void _onLoadAllTaskTabs(LoadAllTaskTabs event, Emitter<MainTabState> emit) {
    try {
      final tasks = TaskTabService.getAllTaskTabService();
      emit(state.copyWith(taskTabs: tasks));
    } catch (error) {
      print("error load all task tabs: $error");
    }
  }

  Future<void> _onAddTaskTab(AddTaskTab event, Emitter<MainTabState> emit) async {
    try {
      TaskTab newTab = TaskTab(
        id: "tab-${uuid.v4()}",
        tabName: event.tabName,
      );
      final updatedTabs = List<TaskTab>.from(state.taskTabs)..add(newTab);
      await TaskTabService.saveTaskTabService(newTab);
      emit(state.copyWith(taskTabs: updatedTabs));
    } catch (error) {
      print("error adding tab: $error");
    }
  }

  Future<void> _onEditTaskTab(
    EditTaskTab event,
    Emitter<MainTabState> emit,
  ) async {
    try {
      final index = state.taskTabs.indexWhere((tab) => tab.id == event.id);
      if (index == -1) return;

      TaskTab updatedTab = TaskTab(id: event.id, tabName: event.tabName);
      final updatedTabs = List<TaskTab>.from(state.taskTabs);
      updatedTabs[index] = updatedTab;

      await TaskTabService.saveTaskTabService(updatedTab);
      emit(state.copyWith(taskTabs: updatedTabs));
    } catch (error) {
      print("error editing tab: $error");
    }
  }

  Future<void> _onDeleteTaskTab(
    DeleteTaskTab event,
    Emitter<MainTabState> emit,
  ) async {
    try {
      final updatedTabs =
          state.taskTabs.where((tab) => tab.id != event.id).toList();
      await TaskTabService.deleteTaskTabService(event.id);
      emit(state.copyWith(taskTabs: updatedTabs));
    } catch (error) {
      print("error deleting task tab: $error");
    }
  }

  void _onChangeTab(ChangeTab event, Emitter<MainTabState> emit) {
    if (mainTabController.index != event.index) {
      mainTabController.jumpToTab(event.index);
    }
    emit(state.copyWith(currentIndex: event.index));
  }

  @override
  Future<void> close() {
    mainTabController.dispose();
    return super.close();
  }
}
