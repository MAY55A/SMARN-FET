import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/services/auth_service.dart';

class AdminService {
  final AuthService _authService = AuthService();

  Future<bool> login(String email, String password) async {
    try {
      User? user =
          await _authService.signInWithEmailAndPassword(email, password);
      // Check if this user is the admin (assuming admin UID is known)
      if (await _authService.isAdmin(user)) {
        print("Admin logged in successfully.");
        print(user!.uid);
        return true;
      } else {
        print("Unauthorized access attempt.");
        return false;
      }
    } catch (e) {
      print("Error logging in admin: $e");
      return false;
    }
  }
}
