import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import { generateId } from "../helpers/id_generator";
import { documentExists } from "../helpers/check_existence";
import {
  ActivityTag,
  ConstraintCategory,
  RoomType,
  SchedulingRule,
  SchedulingRuleType,
  SpaceConstraint,
  SpaceConstraintType,
  TimeConstraint,
  TimeConstraintType,
  WorkDay,
} from "../models";

const db = admin.firestore();

/*
  TO BE ADDED:
  - Add test for startime and endTime format and validity
  - Add test for validity of updatedData in the updateConstraint function
*/


// function to add a time Constraint
export const createTimeConstraint = functions.https.onCall(async (request) => {
  const { constraintData } = request.data;

  // Ensure only admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can create constraints."
    );
  }

  // Ensure the Constraint data is provided
  if (
    !constraintData.type ||
    !constraintData.startTime ||
    !constraintData.endTime ||
    !constraintData.availableDays
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: type, startTime, endTime and availableDays"
    );
  }

  // Ensure all constraint days are valid
  constraintData.availableDays.forEach((day: String) => {
    if (!Object.values(WorkDay).includes(day as WorkDay)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid work days"
      );
    }
  });

  // Ensure time constraint type is valid
  if (
    !Object.values(TimeConstraintType).includes(
      constraintData.type as TimeConstraintType
    )
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid time constraint type"
    );
  }

  if (constraintData.type == TimeConstraintType.teacherAvailability) {
    var idType = "teacher";
  } else if (constraintData.type == TimeConstraintType.classAvailability) {
    var idType = "class";
  }
  else {
    var idType = "room";
  }
  if (!constraintData[idType + "Id"]) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: " + idType + "Id"
    );
  } else {
    // Ensure the id is valid
    if (!(await documentExists(idType == "class" ? "classes" : idType + "s", "id", constraintData[idType + "Id"]))) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Invalid " + idType
      );
    } else {
      // Ensure the constraint does not already exist on the same days
      const constraintSnapshot = await db
        .collection("constraints")
        .where("type", "==", constraintData.type)
        .where(idType + "Id", "==", constraintData[idType + "Id"])
        .where("availableDays", "array-contains-any", constraintData.availableDays)
        .get();
      if (!constraintSnapshot.empty) {
        throw new functions.https.HttpsError(
          "already-exists",
          "A constraint on the same day already exists for this " + idType
        );
      }
    }
  }

  try {
    // Generate a unique Constraint ID
    const constraintId = await generateId("CONST", "constraints");

    // Prepare the Constraint document
    const newConstraint: TimeConstraint = {
      id: constraintId,
      category: ConstraintCategory.timeConstraint,
      type: constraintData.type,
      startTime: constraintData.startTime,
      endTime: constraintData.endTime,
      availableDays: constraintData.availableDays,
      teacherId: constraintData.teacherId,
      classId: constraintData.classId,
      roomId: constraintData.roomId,
      isActive: true,
    };

    // Save the Constraint document in Firestore
    await db.collection("constraints").doc(constraintId).set(newConstraint);

    return {
      message: "Time constraint created successfully!",
      success: true,
    };
  } catch (error) {
    throw error;
  }
});

// function to add a space Constraint
export const createSpaceConstraint = functions.https.onCall(async (request) => {
  const { constraintData } = request.data;

  // Ensure only admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can create constraints."
    );
  }

  // Ensure the Constraint type is provided
  if (
    !constraintData.type
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: type"
    );
  }

  // Ensure space constraint type is valid
  if (
    !Object.values(SpaceConstraintType).includes(
      constraintData.type as SpaceConstraintType
    )
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid space constraint type"
    );
  }

  if (constraintData.type === SpaceConstraintType.roomType) {
    if (!constraintData.activityType || !constraintData.requiredRoomType) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required parameters: activityType and requiredRoomType"
      );
    } else {
      // Ensure space constraint type is valid
      if (
        !Object.values(RoomType).includes(
          constraintData.requiredRoomType as RoomType
        ) || !Object.values(ActivityTag).includes(
          constraintData.activityType as ActivityTag
        )
      ) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid room type or activity type"
        );
      } else {
        // Ensure a constraint does not already exist for the same activity type
        const constraintSnapshot = await db
          .collection("constraints")
          .where("activityType", "==", constraintData.activityType)
          .get();
        if (!constraintSnapshot.empty) {
          throw new functions.https.HttpsError(
            "already-exists",
            "A constraint for the same activity type already exists."
          );
        }
      }
    }
  }

  if (constraintData.type === SpaceConstraintType.preferredRoom) {
    if (!constraintData.roomId || !(constraintData.classId || constraintData.subjectId || constraintData.teacherId)) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required parameter: roomId and either classId, subjectId or teacherId"
      );
    } else {
      // Ensure the room is valid
      if (!(await documentExists("rooms", "id", constraintData.roomId))) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid room"
        );
      } else {
        // Ensure the class is valid if provided
        if (constraintData.classId && !(await documentExists("classes", "id", constraintData.classId))) {
          throw new functions.https.HttpsError(
            "invalid-argument",
            "Invalid class"
          );
        }
        // Ensure the subject is valid if provided
        if (constraintData.subjectId && !(await documentExists("subjects", "id", constraintData.subjectId))) {
          throw new functions.https.HttpsError(
            "invalid-argument",
            "Invalid subject"
          );
        }
        // Ensure the teacher is valid if provided
        if (constraintData.teacherId && !(await documentExists("teachers", "id", constraintData.teacherId))) {
          throw new functions.https.HttpsError(
            "invalid-argument",
            "Invalid teacher"
          );
        }
      }
    }
  }


  try {
    // Generate a unique Constraint ID
    const constraintId = await generateId("CONST", "constraints");

    // Prepare the Constraint document
    const newConstraint: SpaceConstraint = {
      id: constraintId,
      category: ConstraintCategory.spaceConstraint,
      type: constraintData.type,
      roomId: constraintData.roomId,
      subjectId: constraintData.subjectId,
      activityType: constraintData.activityType,
      requiredRoomType: constraintData.requiredRoomType,
      teacherId: constraintData.teacherId,
      classId: constraintData.classId,
      isActive: true,
    };

    // Save the Constraint document in Firestore
    await db.collection("constraints").doc(constraintId).set(newConstraint);

    return {
      message: "Space constraint created successfully!",
      success: true,
    };
  } catch (error) {
    throw error;
  }
});

// function to add a scheduling rule
export const createSchedulingRule = functions.https.onCall(async (request) => {
  const { constraintData } = request.data;

  // Ensure only admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can create constraints."
    );
  }

  // Ensure the scheduling rule type is provided
  if (
    !constraintData.type
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: type"
    );
  }

  // Ensure scheduling rule type is valid
  if (
    !Object.values(SchedulingRuleType).includes(
      constraintData.type as SchedulingRuleType
    )
  ) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid scheduling rule type"
    );
  }

  if (constraintData.type == SchedulingRuleType.workPeriod || constraintData.type == SchedulingRuleType.breakPeriod) {
    if (!constraintData.startTime || !constraintData.endTime || !constraintData.applicableDays) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required parameters: startTime, endTime and applicableDays"
      );
    } else {
      // Ensure applicableDays is valid
      if (!constraintData.applicableDays.every((day: String) => Object.values(WorkDay).includes(day as WorkDay))) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "Invalid applicableDays"
        );
      } else {
        // Ensure a rule does not already exist on the same days for this type
        const constraintSnapshot = await db
          .collection("constraints")
          .where("type", "==", constraintData.type)
          .where("applicableDays", "array-contains-any", constraintData.applicableDays)
          .get();
        if (!constraintSnapshot.empty) {
          throw new functions.https.HttpsError(
            "already-exists",
            "A scheduling rule of this type already exists on the same day."
          );
        }
      }
    }
  } else {
    // schedule rule type is minActivityDuration or maxActivityDuration
    if (!constraintData.duration) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "Missing required parameter: duration"
      );
    } else {
      // Ensure the rule does not already exist
      const constraintSnapshot = await db
        .collection("constraints")
        .where("type", "==", constraintData.type)
        .get();
      if (!constraintSnapshot.empty) {
        throw new functions.https.HttpsError(
          "already-exists",
          "A scheduling rule of this type already exists."
        );
      }
    }
  }

  try {
    // Generate a unique Constraint ID
    const constraintId = await generateId("CONST", "constraints");

    // Prepare the Constraint document
    const newConstraint: SchedulingRule = {
      id: constraintId,
      category: ConstraintCategory.schedulingRule,
      type: constraintData.type,
      startTime: constraintData.startTime,
      endTime: constraintData.endTime,
      applicableDays: constraintData.applicableDays,
      duration: constraintData.duration,
      isActive: true,
    };

    // Save the Constraint document in Firestore
    await db.collection("constraints").doc(constraintId).set(newConstraint);

    return {
      message: "Scheduling Rule created successfully!",
      success: true,
    };
  } catch (error) {
    throw error;
  }
});

export const getConstraint = functions.https.onCall(async (request) => {
  const { constraintId } = request.data;

  // Ensure only admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view constraints."
    );
  }

  // Check if the Constraint id is provided
  if (!constraintId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: constraintId"
    );
  }

  const constraintRef = db.collection("constraints").doc(constraintId);
  const constraintDoc = await constraintRef.get();

  if (!constraintDoc.exists) {
    throw new functions.https.HttpsError(
      "not-found",
      "Constraint not found"
    );
  }

  return constraintDoc.data();
});

export const getAllConstraints = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view constraints."
    );
  }

  try {
    // Fetch all Constraints from Firestore
    const constraintsSnapshot = await admin
      .firestore()
      .collection("constraints")
      .get();
    const constraintsList: any[] = [];

    constraintsSnapshot.forEach((doc) => {
      constraintsList.push(doc.data());
    });

    return { constraints: constraintsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching constraints",
      error
    );
  }
});

export const getMinMaxDuration = functions.https.onCall(async (request) => {
  const { type } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view min/max activity durations."
    );
  }

  // Ensure type is provided and valid
  if (type != 'min' && type != 'max') {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid type. Type should be either 'min' or 'max'"
    );
  }

    const constraintSnapshot = await db
      .collection("constraints")
      .where("type", "==", type == 'min' ? SchedulingRuleType.minActivityDuration : SchedulingRuleType.maxActivityDuration)
      .limit(1)
      .get();

    if(constraintSnapshot.empty) {
      throw new functions.https.HttpsError(
        "not-found",
        "No constraint for " + type + " activity duration found"
      );
    }
    return { duration: constraintSnapshot.docs[0].data().duration };
});

export const getConstraintsByCategory = functions.https.onCall(async (request) => {
  const { category } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view constraints."
    );
  }

  try {
    // Fetch Constraints by category from Firestore
    const constraintsSnapshot = await admin
      .firestore()
      .collection("constraints")
      .where("category", "==", category)
      .get();
    const constraintsList: any[] = [];

    constraintsSnapshot.forEach((doc) => {
      constraintsList.push(doc.data());
    });

    return { constraints: constraintsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching constraints by category",
      error
    );
  }
});

export const getActiveConstraints = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view constraints."
    );
  }

  try {
    const constraintsSnapshot = await db
      .collection("constraints")
      .where("isActive", "==", true)
      .get();

    const constraintsList: any[] = [];

    constraintsSnapshot.forEach((doc) => {
      constraintsList.push(doc.data());
    });

    return { constraints: constraintsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching active constraints",
      error
    );
  }
}
);

export const getActiveConstraintsByCategory = functions.https.onCall(async (request) => {
  const { category } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view constraints."
    );
  }

  try {
    const constraintsSnapshot = await db
      .collection("constraints")
      .where("category", "==", category)
      .where("isActive", "==", true)
      .get();

    const constraintsList: any[] = [];

    constraintsSnapshot.forEach((doc) => {
      constraintsList.push(doc.data());
    });

    return { constraints: constraintsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching active constraints by category",
      error
    );
  }
}
);

export const updateConstraint = functions.https.onCall(async (request) => {
  const { constraintId, updateData } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update constraints."
    );
  }
  // Check if the Constraint id and its updated data are provided
  if (!constraintId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: constraintId, updateData"
    );
  }

  const constraintRef = db.collection("constraints").doc(constraintId);
  const constraintDoc = await constraintRef.get();

  if (!constraintDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Constraint not found");
  }

  try {
    // Use the updateData directly from the request
    await constraintRef.update(updateData);
    return { message: "Constraint updated successfully!", success: true };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating constraint data",
      error
    );
  }
});

export const deleteConstraint = functions.https.onCall(async (request) => {
  const { constraintId } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete constraints."
    );
  }
  // Check if the Constraint id is povided
  if (!constraintId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: constraintId"
    );
  }

  const constraintRef = db.collection("constraints").doc(constraintId);
  const constraintDoc = await constraintRef.get();

  if (!constraintDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Constraint not found");
  }

  try {
    // Delete the Constraint's Firestore document
    await db.collection("constraints").doc(constraintId).delete();

    return { message: "Constraint deleted successfully!", success: true };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting constraint",
      error
    );
  }
});
