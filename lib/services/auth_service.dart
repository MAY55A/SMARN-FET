import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In method
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  // Sign Out method
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  // Check if user is admin
  Future<bool> isAdmin(User? user) async {
    if (user == null) return false;
    DocumentSnapshot userDoc = await _firestore.collection('admin').doc(user.uid).get();
    return userDoc.exists;
  }

  // Check if user is teacher
  Future<bool> isTeacher(User? user) async {
  if (user == null) return false;
  try {
    DocumentSnapshot userDoc = await _firestore.collection('teachers').doc(user.uid).get();
    print('Checking if user is a teacher: ${user.uid}, Exists: ${userDoc.exists}');
    return userDoc.exists;
  } catch (e) {
    print('Error checking if user is a teacher: $e');
    return false; // Return false if there's an error
  }
}

  
  User? getCurrentUser() {
    return _auth.currentUser;
  }


  // Create a new user
  Future<User?> register(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print('Error registering new user: $e');
      return null;
    }
  }

  
}