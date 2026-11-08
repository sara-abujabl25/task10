
import 'package:supabase_flutter/supabase_flutter.dart';

enum AuthOutcome {
  signedIn,
  needsEmailConfirmation,
}

class AuthFailure implements Exception {
  final String message;

  const AuthFailure(this.message);

  @override
  String toString() => message;
}

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<AuthOutcome> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw const AuthFailure(
          'Could not create the account. Please try again.',
        );
      }

      return response.session == null
          ? AuthOutcome.needsEmailConfirmation
          : AuthOutcome.signedIn;
    } on AuthApiException catch (e) {
      throw AuthFailure(e.message);
    } on AuthException catch (e) {
      throw AuthFailure(e.message);
    } on AuthFailure {
      rethrow;
    } catch (_) {
      throw const AuthFailure(
        'Network problem. Check your connection.',
      );
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}
