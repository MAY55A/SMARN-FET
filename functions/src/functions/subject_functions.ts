import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {generateId} from "../helpers/id_generator";
import {Subject} from "../models";
import {documentExists} from "../helpers/check_existence";

const db = admin.firestore();

// function to add a subject
export const addSubject = functions.https.onCall(async (request) => {
  const {subjectData} = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can add subjects."
    );
  }

  // Ensure the subject data is provided
  if (!subjectData.name || !subjectData.longName || !subjectData.description) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: name, longName, description"
    );
  }

  // Ensure the subject does not already exist
  if (await documentExists("subjects", "name", subjectData.name)) {
    throw new functions.https.HttpsError(
      "already-exists",
      "A subject with the same name already exists."
    );
  }

  try {
    // Generate a unique subject ID
    const subjectId = await generateId("SUB", "subjects");

    // Prepare the subject document
    const newsubject: Subject = {
      id: subjectId,
      name: subjectData.name,
      longName: subjectData.longName,
      description: subjectData.description,
    };

    // Save the subject document in Firestore
    await db.collection("subjects").doc(subjectId).set(newsubject);

    return {
      message: "Subject added successfully!",
      success: true,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error adding subject",
      error
    );
  }
});

export const getSubject = functions.https.onCall(async (request) => {
  const {subjectId} = request.data;

  // Check if the subject id is provided
  if (!subjectId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: subjectId"
    );
  }
  // Fetch subject data from Firestore
  const subjectDoc = await db.collection("subjects").doc(subjectId).get();

  if (!subjectDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Subject not found");
  }

  return subjectDoc.data();
});

export const getAllSubjects = functions.https.onCall(async (request) => {
  try {
    // Fetch all subjects from Firestore
    const subjectsSnapshot = await db.collection("subjects").get();
    const subjectsList: any[] = [];

    subjectsSnapshot.forEach((doc) => {
      subjectsList.push(doc.data());
    });

    return {subjects: subjectsList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching subjects data",
      error
    );
  }
});

export const updateSubject = functions.https.onCall(async (request) => {
  const {subjectId, updateData} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update subjects."
    );
  }

  // Check if the subject id and its updated data are provided
  if (!subjectId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: subjectId, updateData"
    );
  }

  const subjectRef = db.collection("subjects").doc(subjectId);
  const subjectDoc = await subjectRef.get();

  if (!subjectDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Subject not found");
  }

  try {
    // Use the updateData directly from the request
    await subjectRef.update(updateData);

    return {message: "Subject updated successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating subject data",
      error
    );
  }
});

export const deleteSubject = functions.https.onCall(async (request) => {
  const {subjectId} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete subjects"
    );
  }

  // Check if the subject id is povided
  if (!subjectId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: subjectId"
    );
  }

  try {
    const subjectRef = db.collection("subjects").doc(subjectId);
    const activitiesRef = db.collection("activities");
    const teachersRef = db.collection("teachers");

    await db.runTransaction(async (transaction) => {
      // Find all activities with the subject reference
      const activitiesSnapshot = await activitiesRef
        .where("subject", "==", subjectId)
        .get();

      // delete the activities
      activitiesSnapshot.forEach((activityDoc) => {
        transaction.delete(activityDoc.ref);
      });

      // Find all teachers with the subject reference
      const teachersSnapshot = await teachersRef
        .where("subjects", "array-contains", subjectId)
        .get();

      // Update each teacher's subjects array by deleting the subject from it
      teachersSnapshot.forEach((teacherDoc) => {
        transaction.update(teacherDoc.ref, {
          subjects: admin.firestore.FieldValue.arrayRemove(subjectId),
        });
      });

      // Delete the subject's Firestore document
      transaction.delete(subjectRef);
    });

    return {message: "Subject deleted successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting subject",
      error
    );
  }
});

export async function getBasicSubjectDetails(id: string) {
  const teacherDoc = db.collection("subjects").doc(id);
  const doc = await teacherDoc.get();
  if (!doc.exists) {
    throw new Error("Subject not found");
  }
  return {
    id: doc.data()?.id, name: doc.data()?.name,
    longName: doc.data()?.longName
  };
}
