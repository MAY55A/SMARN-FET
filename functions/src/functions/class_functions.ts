import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {generateId} from "../helpers/id_generator";
import {Class} from "../models";
import {documentExists} from "../helpers/check_existence";
import {generateAccessKey} from "../helpers/key_generator";

const db = admin.firestore();

// function to add a class
export const addClass = functions.https.onCall(async (request) => {
  const {classData} = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can add classes."
    );
  }


  // Check if the class data is provided
  if (!classData.name || !classData.longName || !classData.nbStudents) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: name, longName, nbStudents"
    );
  }

  // Ensure the classe does not already exist
  if (await documentExists("classes", "name", classData.name)) {
    throw new functions.https.HttpsError(
      "already-exists",
      "A class with the same name already exists."
    );
  }

  try {
    // Generate a unique class ID
    const classId = await generateId("CLA", "classes");
    const classKey = generateAccessKey();

    // Prepare the classe document
    const newClass: Class = {
      id: classId,
      name: classData.name,
      longName: classData.longName,
      nbStudents: classData.nbStudents,
      accessKey: classKey,
    };

    // Save the classe document in Firestore
    await db.collection("classes").doc(classId).set(newClass);

    return {
      message: "Class added successfully!",
      success: true,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error adding class",
      error
    );
  }
});

export const getClass = functions.https.onCall(async (request) => {
  const {className, classKey} = request.data;

  // Check if the class id and class key are provided
  if (!className || !classKey) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: classId, classKey"
    );
  }
  // look up the class
  const query = await db
    .collection("classes")
    .where("name", "==", className)
    .where("accessKey", "==", classKey)
    .limit(1)
    .get();

  if (query.empty) {
    throw new functions.https.HttpsError("not-found",
      "Class not found or access key does not match");
  }

  const classDoc = query.docs[0];
  return classDoc.data();
});

export const getAllClasses = functions.https.onCall(async (request) => {
  // Check if the requesting user is allowed to view the classes
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view classes."
    );
  }

  try {
    // Fetch all classes from Firestore
    const classesSnapshot = await db
      .collection("classes")
      .get();
    const classesList: any[] = [];

    classesSnapshot.forEach((doc) => {
      classesList.push(doc.data());
    });

    return {classes: classesList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching classes data",
      error
    );
  }
});

export const updateClass = functions.https.onCall(async (request) => {
  const {classId, updateData} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to update this class."
    );
  }

  // Check if the class id and its updated data are povided
  if (!classId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: classId, updateData"
    );
  }
  const classRef = db.collection("classes").doc(classId);
  const classDoc = await classRef.get();

  if (!classDoc.exists) {
    throw new functions.https.HttpsError("not-found", "class not found");
  }

  try {
    // Use the updateData directly from the request
    await classRef.update(updateData);

    return {message: "class updated successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating class data",
      error
    );
  }
});

export const regenerateClassKey = functions.https.onCall(async (request) => {
  const {classId} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to change the class key."
    );
  }

  // Check if the class id and its updated data are povided
  if (!classId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: classId"
    );
  }
  const classRef = db.collection("classes").doc(classId);
  const classDoc = await classRef.get();

  if (!classDoc.exists) {
    throw new functions.https.HttpsError("not-found", "class not found");
  }

  try {
    // generate a new class key
    const newKey = generateAccessKey();

    // Use the class with the new key
    await classRef.update({accessKey: newKey});

    return {message: "class key changed successfully ! new key : " + newKey, success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error changing class key",
      error
    );
  }
});

export const deleteClass = functions.https.onCall(async (request) => {
  const {classId} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete classes"
    );
  }

  // Check if the class id is provided
  if (!classId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: classId"
    );
  }

  try {
    const classRef = db.collection("classes").doc(classId);
    const activitiesRef = db.collection("activities");

    await db.runTransaction(async (transaction) => {
      // Find all activities with the class reference
      const activitiesSnapshot = await activitiesRef
        .where("studentsClass", "==", classId)
        .get();

      // delete the activities
      activitiesSnapshot.forEach((activityDoc) => {
        transaction.delete(activityDoc.ref);
      });

      // Delete the class's Firestore document
      transaction.delete(classRef);
    });

    return {message: "class deleted successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting class",
      error
    );
  }
});

export function getBasicClassDetails(id: string) {
  const teacherDoc = db.collection("classes").doc(id);
  return teacherDoc.get().then((doc) => {
    if (!doc.exists) {
      throw new Error("Class not found");
    }
    return {
      id: doc.data()?.id, name: doc.data()?.name,
      longName: doc.data()?.longName,
    };
  });
}
