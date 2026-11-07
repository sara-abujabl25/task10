
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  List<Map<String, dynamic>> tasks = [];

  Future<void> loadTasks() async {
    emit(TaskLoading());

    try {
      final savedTasks = await _prefs.getString('tasks');

      if (savedTasks != null) {
        final List<dynamic> decodedTasks = jsonDecode(savedTasks);

        tasks = decodedTasks
            .map((task) => Map<String, dynamic>.from(task))
            .toList();
      }

      emit(TaskSuccess(List.from(tasks)));
    } catch (e) {
      emit(TaskError('Failed to load tasks: $e'));
    }
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String priority,
  }) async {
    emit(TaskLoading());

    try {
      final updatedTasks =
          List<Map<String, dynamic>>.from(tasks);

      updatedTasks.add({
        'title': title,
        'description': description,
        'priority': priority,
        'completed': false,
      });

      await _saveTasks(updatedTasks);

      tasks = updatedTasks;

      emit(TaskSuccess(List.from(tasks)));
    } catch (e) {
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> toggleTask(int index) async {
    emit(TaskLoading());

    try {
      final updatedTasks = tasks
          .map((task) => Map<String, dynamic>.from(task))
          .toList();

      updatedTasks[index]['completed'] =
          !(updatedTasks[index]['completed'] == true);

      await _saveTasks(updatedTasks);

      tasks = updatedTasks;

      emit(TaskSuccess(List.from(tasks)));
    } catch (e) {
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> deleteTask(int index) async {
    emit(TaskLoading());

    try {
      final updatedTasks = tasks
          .map((task) => Map<String, dynamic>.from(task))
          .toList();

      updatedTasks.removeAt(index);

      await _saveTasks(updatedTasks);

      tasks = updatedTasks;

      emit(TaskSuccess(List.from(tasks)));
    } catch (e) {
      emit(TaskError('Failed to delete task: $e'));
    }
  }

  Future<void> _saveTasks(
    List<Map<String, dynamic>> tasksToSave,
  ) async {
    await _prefs.setString(
      'tasks',
      jsonEncode(tasksToSave),
    );
  }
}
