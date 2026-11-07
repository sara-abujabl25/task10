
import 'package:dio/dio.dart';

import '../models/online_task_model.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<QuoteModel>> fetchTasks() async {
    final response = await _dio.get(
      'https://dummyjson.com/quotes?limit=5',
    );

    final data = Map<String, dynamic>.from(response.data);
    final List<dynamic> quotes = data['quotes'];

    return quotes
        .map((item) {
          return QuoteModel.fromJson(
            Map<String, dynamic>.from(item),
          );
        })
        .where((quote) => quote.id != 2)
        .toList();
  }
}
