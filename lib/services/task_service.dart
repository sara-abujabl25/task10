
import 'package:supabase_flutter/supabase_flutter.dart';

class TaskService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getTasks() async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final response = await _supabase
        .from('tasks')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response.map((task) {
      return {
        'id': task['id'],
        'title': task['title'],
        'description': task['description'],
        'priority': task['priority'],
        'completed': task['is_completed'],
      };
    }).toList();
  }

  Future<void> addTask({
    required String title,
    required String description,
    required String priority,
  }) async {
    final user = _supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _supabase.from('tasks').insert({
      'user_id': user.id,
      'title': title,
      'description': description,
      'priority': priority,
    });
  }

  Future<void> updateTask({
    required int id,
    required bool completed,
  }) async {
    await _supabase
        .from('tasks')
        .update({'is_completed': completed})
        .eq('id', id);
  }

  Future<void> deleteTask(int id) async {
    await _supabase
        .from('tasks')
        .delete()
        .eq('id', id);
  }
}
