import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import { generateId } from "../helpers/id_generator";
import { Schedule } from "../models";

const db = admin.firestore();

// function to add a schedule
export const createSchedules = functions.https.onCall(async (request) => {
  const { schedules } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can create schedules."
    );
  }

  try {


    schedules.forEach(async (s: any) => {
      // Generate a unique schedule ID
      const scheduleId = await generateId("SCHD", "schedules");

      // Prepare the schedule document
      const newschedule: Schedule = {
        id: scheduleId,
        creationDate: new Date().toISOString(),
        belongsTo: s.belongsTo,
        activities: s.activities,
        logs: s.logs,
      };

      // Save the schedule document in Firestore
      await db.collection("schedules").doc(scheduleId).set(newschedule);
    });



    return {
      message: "Schedules created successfully!",
      success: true,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error creating schedules",
      error
    );
  }
});

export const getLatestScheduleFor = functions.https.onCall(async (request) => {
  const { id } = request.data;

  // Check if the schedule id is provided
  if (!id) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: id"
    );
  }
  try {
    // Query Firestore for schedules belonging to the given id
    const schedulesQuerySnapshot = await db
      .collection("schedules")
      .where("belongsTo", "==", id)
      .orderBy("creationDate", "desc") // Ensure the most recent is fetched first
      .limit(1) // Fetch only the latest schedule
      .get();

    // Check if any schedules exist
    if (schedulesQuerySnapshot.empty) {
      throw new functions.https.HttpsError("not-found", "Schedule not found");
    }

    // Retrieve the first (latest) schedule document
    const latestScheduleDoc = schedulesQuerySnapshot.docs[0];

    // Return the latest schedule data
    return latestScheduleDoc.data();
  } catch (error) {
    console.error("Error fetching latest schedule:", error);
    throw new functions.https.HttpsError(
      "internal",
      "An error occurred while fetching the schedule"
    );
  }
});

export const getSchedulesForType = functions.https.onCall(async (request) => {
  const { type } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view all schedules."
    );
  }
  // Check if the schedule id is provided
  if (type != "TEA" && type != "CLA" && type != "RM") {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: type (TEA, CLA, RM)"
    );
  }
  try {
    // Fetch all schedules from Firestore
    const schedulesSnapshot = await db.collection("schedules").where("belongsTo", "==", type + "%").get();
    const schedulesList: any[] = [];

    schedulesSnapshot.forEach((doc) => {
      schedulesList.push(doc.data());
    });

    return { schedules: schedulesList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching schedules data",
      error
    );
  }
});

export const updateSchedule = functions.https.onCall(async (request) => {
  const { scheduleId, updateData } = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update schedules."
    );
  }

  // Check if the schedule id and its updated data are provided
  if (!scheduleId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: scheduleId, updateData"
    );
  }

  const scheduleRef = db.collection("schedules").doc(scheduleId);
  const scheduleDoc = await scheduleRef.get();

  if (!scheduleDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Schedule not found");
  }

  try {
    // Use the updateData directly from the request
    await scheduleRef.update(updateData);

    return { message: "Schedule updated successfully!", success: true };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating schedule data",
      error
    );
  }
});

export const deleteSchedule = functions.https.onCall(async (request) => {
  const { scheduleId } = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete schedules"
    );
  }

  // Check if the schedule id is povided
  if (!scheduleId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: scheduleId"
    );
  }
  const scheduleRef = db.collection("schedules").doc(scheduleId);
  const scheduletDoc = await scheduleRef.get();

  if (!scheduletDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Schedule not found");
  }

  try {
    // Delete the Schedule's Firestore document
    await db.collection("schedules").doc(scheduleId).delete();
    return { message: "Schedule deleted successfully!", success: true };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting schedule",
      error
    );
  }
});
