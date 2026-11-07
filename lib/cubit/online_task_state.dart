import '../models/online_task_model.dart';

abstract class OnlineTaskState {}

class OnlineTaskInitial extends OnlineTaskState {}

class OnlineTaskLoading extends OnlineTaskState {}

class OnlineTaskSuccess extends OnlineTaskState {
  final List<QuoteModel> tasks;
  final bool isFromCache;

  OnlineTaskSuccess(
    this.tasks, {
    this.isFromCache = false,
  });
}

class OnlineTaskError extends OnlineTaskState {
  final String message;

  OnlineTaskError(this.message);
}