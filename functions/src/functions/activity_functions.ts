import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import {generateId} from "../helpers/id_generator";
import {Activity, ActivityTag, WorkDay} from "../models";
import {documentExists} from "../helpers/check_existence";
import {freeHours} from "../helpers/get_teacher_free_hours";
import {getBasicSubjectDetails} from "./subject_functions";
import {getBasicTeacherDetails} from "./teacher_functions";
import {getBasicRoomDetails} from "./room_functions";
import {getBasicClassDetails} from "./class_functions";

const db = admin.firestore();

// function to add a activity
export const addActivity = functions.https.onCall(async (request) => {
  const {activityData} = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can add activities."
    );
  }

  // Ensure the activity data is provided
  if (!activityData.subject || !activityData.tag || !activityData.teacher ||
    !activityData.studentsClass || !activityData.duration) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: subject, teacher, class, duration, tag"
    );
  }

  // Ensure the activity subject is valid
  if (!(await documentExists("subjects", "id", activityData.subject))) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid subject"
    );
  }

  // Ensure the activity teacher is valid
  if (!(await documentExists("teachers", "id", activityData.teacher))) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid teacher"
    );
  }

  // Ensure the activity class is valid
  if (!(await documentExists("classes", "id", activityData.studentsClass))) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid studentsClass"
    );
  }

  // Ensure the activity tag is valid
  if (!Object.values(ActivityTag).includes(activityData.tag as ActivityTag)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid activity tag"
    );
  }

  // Ensure the activity day is valid
  if (activityData.day && !Object.values(WorkDay).includes(activityData.day as WorkDay)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid working day"
    );
  }

  // Ensure the teacher has enough free hours for the activity
  if (activityData.duration > (await freeHours(activityData.teacher))*60) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Number of target hours exceeded for this teacher"
    );
  }

  try {
    // Generate a unique activity ID
    const activityId = await generateId("ACT", "activities");

    // Prepare the activity document
    const newActivity: Activity = {
      id: activityId,
      subject: activityData.subject,
      teacher: activityData.teacher,
      studentsClass: activityData.studentsClass,
      tag: activityData.tag,
      duration: activityData.duration,
      isActive: activityData.isActive || true,
    };

    // Save the activity document in Firestore
    await db.collection("activities").doc(activityId).set(newActivity);

    return {
      message: "Activity added successfully!",
      success: true,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error adding activity",
      error
    );
  }
});

export const getActivity = functions.https.onCall(async (request) => {
  const {activityId} = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view activities."
    );
  }

  // Check if the activity id is provided
  if (!activityId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: activityId"
    );
  }
  // Fetch activity data from Firestore
  const activityDoc = await admin
    .firestore()
    .collection("activities")
    .doc(activityId)
    .get();

  if (!activityDoc.exists) {
    throw new functions.https.HttpsError("not-found", "activity not found");
  }

  const activity = activityDoc.data()!;
  activity.subject = await getBasicSubjectDetails(activity.subject);
  activity.teacher = await getBasicTeacherDetails(activity.teacher);
  activity.studentsClass = await getBasicClassDetails(activity.studentsClass);
  activity.room = activity.room == null ? null : await getBasicRoomDetails(activity.room);
  return activity;
});

export const getAllActivities = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view activities."
    );
  }

  try {
    // Fetch all activities from Firestore
    const activitiesSnapshot = await db
      .collection("activities")
      .get();
    const activitiesList: any[] = [];

    for (const doc of activitiesSnapshot.docs) {
      const activity = doc.data()!;
      activity.subject = await getBasicSubjectDetails(activity.subject);
      activity.teacher = await getBasicTeacherDetails(activity.teacher);
      activity.studentsClass = await getBasicClassDetails(activity.studentsClass);
      activity.room = activity.room == null ? null : await getBasicRoomDetails(activity.room);
      activitiesList.push(activity);
    }

    return {activities: activitiesList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching activities data"
    );
  }
});


export const getActiveActivities = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view all active activities."
    );
  }

  try {

    // Fetch all active activities from Firestore
    const activitiesSnapshot = await admin
      .firestore()
      .collection("activities")
      .where("isActive", "==", true)
      .get();
    const activitiesList: any[] = [];

    activitiesSnapshot.forEach((doc) => {
      activitiesList.push(doc.data());
      });

    return {activities: activitiesList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching active activities"
    );
  }
});

export const updateActivity = functions.https.onCall(async (request) => {
  const {activityId, updateData} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update activities."
    );
  }

  // Check if the activity id and its updated data are provided
  if (!activityId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: activityId, updateData"
    );
  }

  if (!(await documentExists("activities", "id", activityId))) {
    throw new functions.https.HttpsError("not-found", "Activity not found");
  }
  try {
    // Use the updateData directly from the request
    await db.collection("activities").doc(activityId).update(updateData);

    return {message: "Activity updated successfully!", success: true};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating activity data",
      error
    );
  }
});

export const deleteActivity = functions.https.onCall(async (request) => {
  const {activityId} = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete activities"
    );
  }

  // Check if the activity id is povided
  if (!activityId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: activityId"
    );
  }

  if (!(await documentExists("activities", "id", activityId))) {
    throw new functions.https.HttpsError("not-found", "Activity not found");
  }
  try {
    db.collection("activities").doc(activityId).delete();
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting activity",
      error
    );
  }
});

export const getActivitiesByTeacher = functions.https.onCall(async (request) => {
  const {teacherDocId} = request.data;

  // Ensure only an admin or the concerned teacher can view his activities
  if (request.auth?.token.role !== "admin" && request.auth?.token.uid !== teacherDocId) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view the provided teacher's activities."
    );
  }

  try {
    // Fetch current teacher's id from Firestore
    const currentTeacherRef = db.collection("teachers").doc(teacherDocId);
    const teacherId = (await currentTeacherRef.get()).data()?.id;

    // Fetch provided teacher's activities from Firestore
    const activitiesSnapshot = await admin
      .firestore()
      .collection("activities")
      .where("teacher", "==", teacherId)
      .get();

    const activitiesList: any[] = [];

    for (const doc of activitiesSnapshot.docs) {
      const activity = doc.data()!;
      activity.subject = await getBasicSubjectDetails(activity.subject);
      activity.teacher = await getBasicTeacherDetails(activity.teacher);
      activity.studentsClass = await getBasicClassDetails(activity.studentsClass);
      activity.room = activity.room == null ? null : await getBasicRoomDetails(activity.room);
      activitiesList.push(activity);
    }
    
    return { activities: activitiesList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching activities data",
      error
    );
  }
});

export const getActivitiesByClass = functions.https.onCall(async (request) => {
  const {classId} = request.data;

  // Ensure only an admin or the concerned teacher can view his activities
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view classes activities."
    );
  }

  try {
    // Fetch provided class's activities from Firestore
    const activitiesSnapshot = await admin
      .firestore()
      .collection("activities")
      .where("studentsClass", "==", classId)
      .get();

    const activitiesList: any[] = [];

    for (const doc of activitiesSnapshot.docs) {
      const activity = doc.data()!;
      activity.subject = await getBasicSubjectDetails(activity.subject);
      activity.teacher = await getBasicTeacherDetails(activity.teacher);
      activity.studentsClass = await getBasicClassDetails(activity.studentsClass);
      activity.room = activity.room == null ? null : await getBasicRoomDetails(activity.room);
      activitiesList.push(activity);
    }

    return {activities: activitiesList};
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching activities data",
      error
    );
  }
});
