import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {generateId} from "../helpers/id_generator";
import {Teacher} from "../models";
import {documentExists} from "../helpers/check_existence";

const db = admin.firestore();

// function to create a teacher account
export const createTeacherAccount = functions.https.onCall(async (request) => {
  const {email, password, teacher} = request.data;

  // Ensure the email, password and teacher are provided
  if (!email || !password || !teacher.name || !teacher.phone || !teacher.nbHours) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: email, password, teacher"
    );
  }

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can create teachers."
    );
  }

  // Ensure the teacher does not already exist
  if (await documentExists("teachers", "name", teacher.name)) {
    throw new functions.https.HttpsError(
      "already-exists",
      "A teacher with the same name already exists."
    );
  }

  try {
    // Create Firebase Auth user
    const userRecord = await admin.auth().createUser({
      email: email,
      password: password,
    });

    // Set custom claim for a teacher
    await admin.auth().setCustomUserClaims(userRecord.uid, {role: "teacher"});

    // Generate a unique teacher ID
    const teacherId = await generateId("TEA", "teachers");

    // Prepare the teacher document
    const newTeacher: Teacher = {
      id: teacherId,
      name: teacher.name,
      email: email,
      phone: teacher.phone,
      picture: teacher.picture,
      nbHours: teacher.nbHours,
      subjects: teacher.subjects || [],
    };

    // Save the teacher document in Firestore
    await db.collection("teachers").doc(userRecord.uid).set(newTeacher);

    return {
      message: "Teacher account created successfully!",
      success: true,
      teacherId,
    };
  } catch (error: any) {
    let errorMessage = "Error creating teacher account.";
    let errorCode: functions.https.FunctionsErrorCode = "internal"; // Default to 'internal'

    // Map Firebase Auth errors to readable messages
    if (error.code === "auth/invalid-email") {
      errorMessage = "Invalid email format.";
      errorCode = "invalid-argument";
    } else if (error.code === "auth/invalid-password" || error.code === "auth/weak-password") {
      errorMessage =
        "Password must contain upper case letters, lower case letters, numbers and has a length of 6 characters at least.";
      errorCode = "invalid-argument";
    } else if (error.code === "auth/email-already-exists") {
      errorMessage = "This email is already in use.";
      errorCode = "already-exists";
    }

    throw new functions.https.HttpsError(
      errorCode,
      errorMessage,
    );
  }
});

export const getTeacher = functions.https.onCall(async (request) => {
  const {teacherDocId} = request.data;

  // Ensure the teacher ID is provided
  if (!teacherDocId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: teacher ID"
    );
  }

  // Check if the requesting user is allowed to view the teacher's account
  if (request.auth?.token.role !== "admin" && request.auth?.uid !== teacherDocId) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view this account."
    );
  }

  try {
    // Fetch teacher data from Firestore
    const teacherDoc = await admin
      .firestore()
      .collection("teachers")
      .doc(teacherDocId)
      .get();

    if (!teacherDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Teacher not found");
    }

    return teacherDoc.data();
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching teacher data",
      error
    );
  }
});

export const getTeacherName = functions.https.onCall(async (request) => {
  const {teacherId} = request.data;

  // Ensure the teacher ID is provided
  if (!teacherId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: teacher ID"
    );
  }

  // Check if the requesting user is allowed to view the teacher's account
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view this teacher's name."
    );
  }

  try {
    const teacherDoc = await getBasicTeacherDetails(teacherId);

    return teacherDoc.name;
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching teacher name",
      error
    );
  }
});

export const getAllTeachers = functions.https.onCall(async (request) => {
  // Check if the requesting user is allowed to view the teachers
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view teachers."
    );
  }

  try {
    // Fetch all teachers from Firestore
    const teachersSnapshot = await admin
      .firestore()
      .collection("teachers")
      .get();
    const teachersList: any[] = [];

    teachersSnapshot.forEach((doc) => {
      teachersList.push({id: doc.id, teacher: doc.data()});
    });

    return {teachers: teachersList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching teachers data",
      error
    );
  }
});

export const updateTeacherAccount = functions.https.onCall(async (request) => {
  const {teacherDocId, updateData} = request.data;

  // Ensure the teacher document ID and updated data are provided
  if (!teacherDocId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: teacherDocId, updateData"
    );
  }

  // Check if the requesting user is allowed to update the teacher's account
  if (request.auth?.token.role !== "admin" && request.auth?.uid !== teacherDocId) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to update this account."
    );
  }
  // Ensure the teacher document exists in Firestore
  const teacherRef = db.collection("teachers").doc(teacherDocId);
  const teacherDoc = await teacherRef.get();

  if (!teacherDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Teacher not found");
  } else if (teacherDoc.data()!.name !== updateData.name) {
    if (await documentExists("teachers", "name", updateData.name)) {
      throw new functions.https.HttpsError(
        "already-exists",
        "A teacher with the same name already exists."
      );
    }
  }

  try {
    // Use the updateData directly from the request
    await teacherRef.update(updateData);

    return {message: "Teacher account updated successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating teacher account",
      error
    );
  }
});

export const deleteTeacherAccount = functions.https.onCall(async (request) => {
  const {teacherDocId} = request.data;

  // Ensure the teacher document ID is provided
  if (!teacherDocId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: teacherDocId"
    );
  }

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin" && request.auth?.uid !== teacherDocId) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to delete this teacher"
    );
  }

  try {
    const teacherRef = db.collection("teachers").doc(teacherDocId);
    const teacherId = (await teacherRef.get()).data()?.id;
    const activitiesRef = db.collection("activities");

    await db.runTransaction(async (transaction) => {
      // Find all activities with the teacher reference
      const activitiesSnapshot = await activitiesRef
        .where("teacher", "==", teacherId)
        .get();

      // delete the activities
      activitiesSnapshot.forEach((activityDoc) => {
        transaction.delete(activityDoc.ref);
      });

      // Delete the teacher's Firestore document
      transaction.delete(teacherRef);
      // Delete the teacher's Firebase Auth account
      await admin.auth().deleteUser(teacherDocId);
    });

    return {message: "Teacher account deleted successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting teacher account",
      error
    );
  }
});

export const getTeachersBySubject = functions.https.onCall(async (request) => {
  const {subjectId} = request.data;

  // Ensure only admin can view them
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view the provided subject's qualified teachers."
    );
  }

  try {
    // Fetch provided subject's teachers from Firestore
    const teachersSnapshot = await db
      .collection("teachers")
      .where("subjects", "array-contains", subjectId)
      .get();

    const teachersList: any[] = [];

    teachersSnapshot.forEach((doc) => {
      teachersList.push({id: doc.data().id, name: doc.data().name});
    });

    return {teachers: teachersList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching teachers data",
      error
    );
  }
});

export const updateTeacherSubjects = functions.https.onCall(async (request) => {
  const {teacherDocId, updatedSubjects} = request.data;

  // Ensure the teacher document ID and updated data are provided
  if (!teacherDocId || !updatedSubjects) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: teacherDocId, updatedSubjects"
    );
  }

  // Check if the requesting user is allowed to update the teacher's subjects
  if (request.auth?.token.role !== "admin" && request.auth?.uid !== teacherDocId) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to update this teacher's subjects."
    );
  }
  // Ensure the teacher document exists in Firestore
  const teacherRef = db.collection("teachers").doc(teacherDocId);
  const teacherDoc = await teacherRef.get();

  if (!teacherDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Teacher not found");
  }

  // Verify each subject exists
  for (const subjectId of updatedSubjects) {
    const exists = await documentExists("subjects", "id", subjectId);
    if (!exists) {
      throw new functions.https.HttpsError(
        "not-found",
        `Subject with ID "${subjectId}" not found`
      );
    }
  }

  try {
    // Use the updatedSubjects directly from the request
    await teacherRef.update({subjects: updatedSubjects});

    return {message: "Teacher subjects updated successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating teacher subjects",
      error
    );
  }
});

export const getAllTeachersNames = functions.https.onCall(async (request) => {
  // Check if the requesting user is allowed to view the classes
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view teachers."
    );
  }

  try {
    // Fetch all classes from Firestore
    const teachersSnapshot = await db
      .collection("teachers")
      .get();
    const teachersList: any[] = [];

    teachersSnapshot.forEach((doc) => {
      teachersList.push(doc.data()?.name);
    });

    return {teachers: teachersList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching teachers names",
      error
    );
  }
});

export async function getBasicTeacherDetails(id: string) {
  const teacherQuery = db.collection("teachers").where("id", "==", id);
  const querySnapshot = await teacherQuery.get();

  if (querySnapshot.empty) {
    throw new Error("Teacher not found");
  }

  const teacherDoc = querySnapshot.docs[0]; // Assuming `id` is unique
  const data = teacherDoc.data();

  return {
    id: data?.id,
    name: data?.name,
  };
}
