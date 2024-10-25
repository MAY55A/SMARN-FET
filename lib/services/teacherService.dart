import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarn/models/teacher.dart';

class Teacherservice {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _teachersCollection =>
      _firestore.collection('teachers');

  // Add a new teacher with custom ID
  Future<void> addTeacherWithCustomId(Map<String, dynamic> teacherData) async {
    try {
      // Get the reference to the counter document
      DocumentReference counterRef =
          _firestore.collection('metadata').doc('teacherCounter');

      // Run the transaction to safely increment the counter and add the teacher
      await _firestore.runTransaction((transaction) async {
        String newTeacherId;
        int newCounter;
        // Get the current counter value
        DocumentSnapshot snapshot = await transaction.get(counterRef);

        if (snapshot.exists) {
          newCounter = (snapshot['count'] ?? 0) + 1;
          // Generate the new teacher ID (e.g., "TEA001")
          newTeacherId = 'TEA${newCounter.toString().padLeft(3, '0')}';
        } else {
          // If the counter doesn't exist, start from 1
          transaction.set(counterRef, {'count': 0});
          newCounter = 1;
          newTeacherId = 'TEA001';
        }
        // Add the teacher document with the custom ID
        transaction.set(_teachersCollection.doc(newTeacherId), {
          ...teacherData, // Add the teacher data
          'id': newTeacherId, // Store the custom ID in the document as well
        });
        // Increment the counter
        transaction.update(counterRef, {'count': newCounter});
      });
    } catch (e, stacktrace) {
      print('Error adding teacher with custom ID: $e');
      print('Stacktrace: $stacktrace');
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
      throw e; // Propagate the error
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
      await _teachersCollection.doc(teacherId).delete();
    } catch (e) {
      print("Error deleting teacher: $e");
      throw e; // Propagate the error
    }
  }
}
