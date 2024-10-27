import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> generateId(String prefix, String collectionName) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    // Reference to the metadata document
    DocumentReference counterDoc =
        firestore.collection('metadata').doc('${collectionName}Counter');
    // Check and create the document if not exists
    DocumentSnapshot snapshot = await counterDoc.get();
    if (!snapshot.exists) {
      print("Document doesn't exist, creating new counter...");
      await counterDoc.set({'count': 0}); // Initialize the count
    }

    // Run transaction to safely increment the counter and generate a unique ID
    String id = await firestore.runTransaction((transaction) async {
      DocumentSnapshot snapshot = await transaction.get(counterDoc);

      // Retrieve current count
      int currentCounter = (snapshot['count'] ?? 0) as int;
      int newCounter = currentCounter + 1;

      // Update the counter
      transaction.update(counterDoc, {'count': newCounter});

      // Generate the new ID
      return prefix + newCounter.toString().padLeft(3, '0');
    });

    return id;
  } catch (e, stacktrace) {
    print('Error generating custom ID: $e');
    print('Stacktrace: $stacktrace');
    throw e;
  }
}
