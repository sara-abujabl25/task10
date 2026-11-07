import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/online_task_model.dart';
import '../services/api_service.dart';
import 'online_task_state.dart';

class OnlineTaskCubit extends Cubit<OnlineTaskState> {
  final ApiService _apiService = ApiService();

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  static const String cacheKey = 'daily_inspiration_cache';

  OnlineTaskCubit() : super(OnlineTaskInitial());

  Future<void> fetchTasks() async {
    emit(OnlineTaskLoading());

    try {
      final quotes = await _apiService.fetchTasks();

      final cachedData = jsonEncode(
        quotes.map((quote) => quote.toJson()).toList(),
      );

      await _prefs.setString(cacheKey, cachedData);

      emit(OnlineTaskSuccess(quotes));
    } catch (e) {
      try {
        final cachedData = await _prefs.getString(cacheKey);

        if (cachedData != null) {
          final List<dynamic> decodedData = jsonDecode(cachedData);

          final quotes = decodedData.map((item) {
            return QuoteModel.fromJson(
              Map<String, dynamic>.from(item),
            );
          }).toList();

          if (quotes.isNotEmpty) {
            emit(
              OnlineTaskSuccess(
                quotes,
                isFromCache: true,
              ),
            );
            return;
          }
        }
      } catch (_) {
        // Cache could not be read.
      }

      emit(
        OnlineTaskError(
          'Unable to load inspiration. Please try again.',
        ),
      );
    }
  }
}