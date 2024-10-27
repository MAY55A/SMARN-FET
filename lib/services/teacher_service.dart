import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smarn/models/teacher.dart';
import 'package:smarn/services/auth_service.dart';
import 'package:smarn/services/id_generator.dart';

class TeacherService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();

  // Collection reference
  CollectionReference get _teachersCollection =>
      _firestore.collection('teachers');

  // Add a new teacher with custom ID
  Future<void> createTeacherAccount(
      String email, String password, Teacher teacher) async {
    try {
      // Step 1: Save the current admin user details
      User? adminUser = _authService.getCurrentUser();
      String adminEmail = adminUser!.email!;
      String adminPassword = "adminkey";

      // Step 2: Create Firebase Auth user
      User? user = await _authService.register(email, password);
      String uid = user!.uid;

      // Step 3: Re-authenticate as admin after teacher creation
      await _authService.signOut();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: adminEmail,
        password: adminPassword,
      );

      // Step 4: Generate a unique ID for the teacher after successful authentication
      String teacherId = await generateId("TEA", "teachers");

      // Step 5: Use the generated ID to create a Teacher instance with updated id
      Teacher newTeacher = Teacher(
        id: teacherId,
        name: teacher.name,
        email: email,
        phone: teacher.phone,
        nbHours: teacher.nbHours,
        subjects: teacher.subjects,
        activities: teacher.activities,
      );

      // Step 6: Save the teacher profile with the custom ID in Firestore
      await _teachersCollection.doc(uid).set(newTeacher.toMap());

      print(
          "Teacher created with custom ID: $teacherId and Firebase UID: $uid as doc ID");
    } catch (e) {
      print("Error creating teacher account: $e");
      throw e;
    }
  }

  Future<bool> login(String email, String password) async {
    User? user = await _authService.signInWithEmailAndPassword(email, password);
    bool isteacher = await _authService.isTeacher(user);
    if (isteacher) {
      print("Teacher logged in successfully.");
      return true;
    } else {
      print("Error logging in teacher.");
      return false;
    }
  }

  Future<Teacher?> fetchTeacherData() async {
    try {
      // Get current user's UID
      String? uid = _authService.getCurrentUser()?.uid;

      if (uid != null) {
        // Retrieve teacher data from Firestore
        DocumentSnapshot teacherDoc = await _teachersCollection.doc(uid).get();

        if (teacherDoc.exists) {
          // Map data to Teacher model or directly use it
          return Teacher.fromMap(teacherDoc.data() as Map<String, dynamic>);
          // Use teacher data to populate the dashboard
        } else {
          print('No teacher data found for this UID.');
          return null;
        }
      } else {
        print('User not authenticated.');
        return null;
      }
    } catch (e) {
      print('Error retrieving teacher data: $e');
      return null;
    }
  }

  // Retrieve a list of teachers
  Future<List<Teacher>> getTeachers() async {
    try {
      final snapshot = await _teachersCollection.get();
      return snapshot.docs.map((doc) {
        return Teacher.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Get document ID
      }).toList();
    } catch (e) {
      print("Error getting teachers: $e");
      return List.empty(); // Propagate the error
    }
  }

  // Update a teacher's information
  Future<void> updateTeacher(Teacher teacher) async {
    try {
      await _teachersCollection.doc(teacher.id).update(teacher.toMap());
    } catch (e) {
      print("Error updating teacher: $e");
      throw e; // Propagate the error
    }
  }

  // Delete a teacher
  Future<void> deleteTeacher(String teacherId) async {
    try {
    } catch (e) {
      print("Error deleting teacher: $e");
      throw e; // Propagate the error
    }
  }

  // Call for teacher to delete his account (not by admin)
  Future<void> deleteTeacherAccount(String teacherId) async {
  try {
    // Delete user document in Firestore
      await _teachersCollection.doc(teacherId).delete();
    print("Teacher document deleted from Firestore.");

    // Delete the authenticated user's account
    User? user = _authService.getCurrentUser();
    if (user != null && user.uid == teacherId) {
      await user.delete();
      print("User deleted from Firebase Auth.");
    } else {
      print("User not authenticated, or mismatched UID.");
    }
  } catch (e) {
    print("Error deleting user: $e");
  }
}
}
