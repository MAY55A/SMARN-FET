import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import { generateId } from "../helpers/id_generator";
import { deleteRoomAndUpdateActivities } from "./room_functions";
import { Building } from "../models";
import { documentExists } from "../helpers/check_existence";

const db = admin.firestore();

// function to add a building
export const addBuilding = functions.https.onCall(async (request) => {
  const { buildingData } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can add buildings."
    );
  }

  // Ensure the building data is provided
  if (!buildingData.name || !buildingData.longName || !buildingData.description) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: name, longName, description"
    );
  }

  // Ensure the building does not already exist
  if (await documentExists("buildings", "name", buildingData.name)) {
    throw new functions.https.HttpsError(
      "already-exists",
      "A building with the same name already exists."
    );
  }

  try {

    // Generate a unique building ID
    const buildingId = await generateId("BLD", "buildings");

    // Prepare the building document
    const newBuilding: Building = {
      id: buildingId,
      name: buildingData.name,
      longName: buildingData.longName,
      description: buildingData.description,
    };

    // Save the building document in Firestore
    await db.collection("buildings").doc(buildingId).set(newBuilding);

    return {
      message: "Building added successfully!",
      success: true,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error adding building",
      error
    );
  }
});

export const getBuilding = functions.https.onCall(async (request) => {
  const { buildingId } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view buildings."
    );
  }

  // Check if the building id is provided
  if (!buildingId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: buildingId"
    );
  }
  // Fetch building data from Firestore
  const buildingDoc = await admin
    .firestore()
    .collection("buildings")
    .doc(buildingId)
    .get();

  if (!buildingDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Building not found");
  }

  return buildingDoc.data();

});

export const getAllBuildings = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view buildings."
    );
  }

  try {
    // Fetch all buildings from Firestore
    const buildingsSnapshot = await admin
      .firestore()
      .collection("buildings")
      .get();
    const buildingsList: any[] = [];

    buildingsSnapshot.forEach((doc) => {
      buildingsList.push(doc.data());
    });

    return { buildings: buildingsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching buildings data",
      error
    );
  }
});

export const updateBuilding = functions.https.onCall(async (request) => {
  const { buildingId, updateData } = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update buildings."
    );
  }

  // Check if the building id and its updated data are provided
  if (!buildingId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: buildingId, updateData"
    );
  }

  const buildingRef = db.collection("buildings").doc(buildingId);
  const buildingDoc = await buildingRef.get();

  if (!buildingDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Building not found");
  }

  try {

    // Use the updateData directly from the request
    await buildingRef.update(updateData);

    return { message: "building updated successfully!", success: true };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating building data",
      error
    );
  }
});

export const deleteBuilding = functions.https.onCall(async (request) => {
  const { buildingId } = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete buildings"
    );
  }

  // Check if the building id is povided
  if (!buildingId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: buildingId"
    );
  }

  const buildingRef = db.collection("buildings").doc(buildingId);

  await db.runTransaction(async (transaction) => {
    // Check if building exists
    const buildingSnapshot = await transaction.get(buildingRef);
    if (!buildingSnapshot.exists) {
      throw new functions.https.HttpsError(
        "not-found",
        "Building not found."
      );
    }

    // Find all rooms with the building reference
    const roomsSnapshot = await db.collection("rooms")
      .where("building", "==", buildingId)
      .get();

    // delete each room
    for (const roomDoc of roomsSnapshot.docs) {
      await deleteRoomAndUpdateActivities(roomDoc);
    };

    // Delete the room document
    transaction.delete(buildingRef);
  });

  return { message: "Building deleted successfully.", success: true };
});
