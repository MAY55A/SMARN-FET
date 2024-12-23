import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/services/auth_service.dart';

class AdminService {
  final AuthService _authService = AuthService();
  final useFunctionsEmulator = 
  FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      if (await _authService.getUserRole(user) == 'admin') {
        return {'success': true, 'message': "Admin logged in successfully."};
      } else {
        _authService.signOut();
        return {
          'success': false,
          'message': "Unauthorized access attempt."
        };
      }
    } catch (e) {
      return {'success': false, 'message': "Login failed. Please check your credentials"};
    }
  }

  Future<void> setAdminRole(String userId) async {
    try {
      final HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('setAdminRole');
      final response = await callable.call({'uid': userId});
      print(response.data); // Success message
    } catch (e) {
      print('Error setting admin role: $e');
    }
  }
}
