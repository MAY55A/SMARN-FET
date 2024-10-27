import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smarn/models/class.dart';
import 'package:smarn/services/id_generator.dart';

class ClassService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection reference
  CollectionReference get _classsCollection => _firestore.collection('classes');

  // Add a new class with custom ID
  Future<void> createClass(Class studentsClass) async {
    String classId = await generateId('CL', 'classes');
    Class newClass = Class(
      id: classId,
      name: studentsClass.name,
      longName: studentsClass.longName,
      nbStudents: studentsClass.nbStudents,
      accessKey: studentsClass.accessKey,
    );
    await _classsCollection.doc(classId).set(newClass.toMap());
    print("class created with custom ID: $classId");
  }

  Future<Class?> login(String className, String classKey) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('classes')
          .where('name', isEqualTo: className)
          .where('accessKey', isEqualTo: classKey)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        DocumentSnapshot classDoc = query.docs.first;
        print("Class found with the provided key.");
        return Class.fromMap(classDoc.data() as Map<String, dynamic>);
      } else {
        print("No class found with that name and key combination.");
        return null;
      }
    } catch (e) {
      print("Error fetching class : $e");
      return null;
    }
  }

  // Retrieve a list of classs
  Future<List<Class>> getclasses() async {
    try {
      final snapshot = await _classsCollection.get();
      return snapshot.docs.map((doc) {
        return Class.fromMap(doc.data() as Map<String, dynamic>)
          ..id = doc.id; // Get document ID
      }).toList();
    } catch (e) {
      print("Error getting classs: $e");
      throw e; // Propagate the error
    }
  }

  // Update a class's information
  Future<void> updateclass(Class studentsClass) async {
    try {
      await _classsCollection
          .doc(studentsClass.id)
          .update(studentsClass.toMap());
    } catch (e) {
      print("Error updating class: $e");
      throw e; // Propagate the error
    }
  }

  // Delete a class
  Future<void> deleteclass(String classId) async {
    try {
      await _classsCollection.doc(classId).delete();
    } catch (e) {
      print("Error deleting class: $e");
      throw e; // Propagate the error
    }
  }
}
