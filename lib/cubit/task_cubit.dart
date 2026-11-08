
import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_state.dart';
import '../services/task_service.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskInitial());

  final TaskService _taskService = TaskService();

  List<Map<String, dynamic>> tasks = [];

  Future<void> loadTasks() async {
    emit(TaskLoading());

    try {
      tasks = await _taskService.getTasks();

      emit(TaskSuccess(List.from(tasks)));
    } catch (e) {
      print('LOAD TASKS ERROR: $e');
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
      await _taskService.addTask(
        title: title,
        description: description,
        priority: priority,
      );

      tasks = await _taskService.getTasks();

      emit(TaskSuccess(List.from(tasks)));

      print('ADD TASK SUCCESS');
    } catch (e) {
      print('ADD TASK ERROR: $e');
      emit(TaskError('Failed to add task: $e'));
    }
  }

  Future<void> toggleTask(int index) async {
    emit(TaskLoading());

    try {
      final task = tasks[index];

      final bool newCompleted = task['completed'] != true;

      await _taskService.updateTask(
        id: task['id'],
        completed: newCompleted,
      );

      tasks = await _taskService.getTasks();

      emit(TaskSuccess(List.from(tasks)));

      print('UPDATE TASK SUCCESS');
    } catch (e) {
      print('UPDATE TASK ERROR: $e');
      emit(TaskError('Failed to update task: $e'));
    }
  }

  Future<void> deleteTask(int index) async {
    emit(TaskLoading());

    try {
      final task = tasks[index];

      await _taskService.deleteTask(task['id']);

      tasks = await _taskService.getTasks();

      emit(TaskSuccess(List.from(tasks)));

      print('DELETE TASK SUCCESS');
    } catch (e) {
      print('DELETE TASK ERROR: $e');
      emit(TaskError('Failed to delete task: $e'));
    }
  }
}
