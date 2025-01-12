import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {generateId} from "../helpers/id_generator";
import {ChangeRequest, ChangeRequestStatus} from "../models";

const db = admin.firestore();

// function to add a changeRequest
export const createChangeRequest = functions.https.onCall(async (request) => {
  const {changeRequestData} = request.data;

  // Ensure only teachers can call this function
  if (request.auth?.token.role !== "teacher") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only teachers can make change requests."
    );
  }

  // Ensure the changeRequest data is provided
  if (!changeRequestData.teacher || !changeRequestData.reason || !changeRequestData.content) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: content, reason, teacher"
    );
  }

  try {
    // Generate a unique changeRequest ID
    const changeRequestId = await generateId("CHRQ", "requests");

    // Prepare the changeRequest document
    const newChangeRequest: ChangeRequest = {
      id: changeRequestId,
      reason: changeRequestData.reason,
      teacher: changeRequestData.teacher,
      content: changeRequestData.content,
      activity: changeRequestData.activity,
      newTimeSlot: changeRequestData.newTimeSlot,
      newRoom: changeRequestData.newRoom,
      submissionDate: new Date().toISOString(),
      status: ChangeRequestStatus.pending,
    };

    // Save the changeRequest document in Firestore
    await db.collection("changeRequests").doc(changeRequestId).set(newChangeRequest);

    return {
      message: "Change request created successfully!",
      success: true,
    };
  } catch (error) {
    throw error;
  }
});

export const getChangeRequest = functions.https.onCall(async (request) => {
  const {changeRequestId} = request.data;

  // Check if the changeRequest id is provided
  if (!changeRequestId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: changeRequestId"
    );
  }

  const changeRequestRef = db.collection("changeRequests").doc(changeRequestId);
  const changeRequestDoc = await changeRequestRef.get();

  if (!changeRequestDoc.exists) {
    throw new functions.https.HttpsError("not-found", "change request not found");
  }

  // Ensure only admins and teachers can view the change request
  if (request.auth?.token.role !== "admin" && request.auth?.token.role !== "teacher") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view change requests."
    );
  }

  // Ensure if not admin only the changeRequest's creator can view the request
  if (request.auth?.token.role !== "admin") {
    const currentTeacherRef = db.collection("teachers").doc(request.auth?.token.uid);
    const currentTeacherId = (await currentTeacherRef.get()).data()?.id;

    if (currentTeacherId !== changeRequestDoc.data()?.teacher) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only this change request's creator can view its content."
      );
    }
  }

  return changeRequestDoc.data();
});

export const getAllChangeRequests = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can see all change requests."
    );
  }

  try {
    // Fetch all changeRequests from Firestore
    const changeRequestsSnapshot = await admin
      .firestore()
      .collection("changeRequests")
      .get();
    const changeRequestsList: any[] = [];

    changeRequestsSnapshot.forEach((doc) => {
      changeRequestsList.push(doc.data());
    });

    return {changeRequests: changeRequestsList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching change requests data",
      error
    );
  }
});

export const updateChangeRequest = functions.https.onCall(async (request) => {
  const {changeRequestId, updateData} = request.data;

  // Check if the changeRequest id and its updated data are provided
  if (!changeRequestId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: changeRequestId, updateData"
    );
  }

  const changeRequestRef = db.collection("changeRequests").doc(changeRequestId);
  const changeRequestDoc = await changeRequestRef.get();

  if (!changeRequestDoc.exists) {
    throw new functions.https.HttpsError("not-found", "changeRequest not found");
  }

  // Ensure only admins and teachers can update change requests
  if (request.auth?.token.role !== "admin" && request.auth?.token.role !== "teacher") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to update change requests."
    );
  }

  // Ensure if not admin only the changeRequest's creator can update the request
  if (request.auth?.token.role !== "admin") {
    const currentTeacherRef = db.collection("teachers").doc(request.auth?.token.uid);
    const currentTeacherId = (await currentTeacherRef.get()).data()?.id;

    if (currentTeacherId !== changeRequestDoc.data()?.teacher) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only this change request's creator can update its content."
      );
    }
  }

  try {
    // Use the updateData directly from the request
    await changeRequestRef.update(updateData);

    return {message: "changeRequest updated successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating changeRequest data",
      error
    );
  }
});

export const deleteChangeRequest = functions.https.onCall(async (request) => {
  const {changeRequestId} = request.data;

  // Check if the changeRequest id is povided
  if (!changeRequestId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: changeRequestId"
    );
  }

  const changeRequestRef = db.collection("changeRequests").doc(changeRequestId);
  const changeRequestDoc = await changeRequestRef.get();

  if (!changeRequestDoc.exists) {
    throw new functions.https.HttpsError("not-found", "changeRequest not found");
  }

  // Ensure only admins and teachers can delete change requests
  if (request.auth?.token.role !== "admin" && request.auth?.token.role !== "teacher") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to delete change requests."
    );
  }

  // Ensure if not admin only the changeRequest's creator can delete the request
  if (request.auth?.token.role !== "admin") {
    const currentTeacherRef = db.collection("teachers").doc(request.auth?.token.uid);
    const currentTeacherId = (await currentTeacherRef.get()).data()?.id;

    if (currentTeacherId !== changeRequestDoc.data()?.teacher) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Only this change request's creator can delete it."
      );
    }
  }

  try {
    // Delete the changeRequest's Firestore document
    await db.collection("changeRequests").doc(changeRequestId).delete();

    return {message: "changeRequest deleted successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting changeRequest",
      error
    );
  }
});

export const getChangeRequestsByTeacher = functions.https.onCall(async (request) => {
  const {teacherDocId} = request.data;

  // Ensure only an admin or the changeRequests' creator can view them
  if (request.auth?.token.role !== "admin" && request.auth?.token.uid !== teacherDocId) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view the provided teacher's change requests."
    );
  }

  try {
    // Fetch current teacher's id from Firestore
    const currentTeacherRef = db.collection("teachers").doc(teacherDocId);
    const teacherId = (await currentTeacherRef.get()).data()?.id;

    // Fetch provided teacher's changeRequests from Firestore
    const changeRequestsSnapshot = await admin
      .firestore()
      .collection("changeRequests")
      .where("teacher", "==", teacherId)
      .get();

    const changeRequestsList: any[] = [];

    changeRequestsSnapshot.forEach((doc) => {
      changeRequestsList.push(doc.data());
    });

    return {changeRequests: changeRequestsList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching change requests data",
      error
    );
  }
});
