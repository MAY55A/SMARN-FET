import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign In method
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign Out method
  Future<String> signOut() async {
    try {
      await _auth.signOut();
      return 'Successfully signed out';
    } catch (e) {
      return 'Error signing out: $e';
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> getUserRole(User? user) async {
    if (user == null) return null;

    try {
      var tokenResult = await user.getIdTokenResult();
      var claims = tokenResult.claims;

      // Return the role (teacher, admin, etc.)
      return claims?['role'];
    } catch (e) {
      print("Error fetching user role: $e");
      return null;
    }
  }
    // Update credentials method (email & password)
  Future<String> updateUserCredentials({
    String? newEmail,
    String? newPassword,
    required String currentPassword,
  }) async {
    User? user = getCurrentUser();

    if (user == null) {
      return "User must be signed in to update credentials.";
    }

    try {
      // Re-authenticate the user
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);

      // Update email if provided
      if (newEmail != null) {
        await user.verifyBeforeUpdateEmail(newEmail);
      }

      // Update password if provided
      if (newPassword != null) {
        await user.updatePassword(newPassword);
      }

      return "Credentials updated successfully!";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        return "Re-authentication required. Please log in again.";
      }
      return e.message ?? "Failed to update credentials.";
    } catch (e) {
      return "An error occurred: $e";
    }
  }
}