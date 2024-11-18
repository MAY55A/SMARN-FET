import * as admin from "firebase-admin";
import * as functions from "firebase-functions/v2";
import { generateId } from "../helpers/id_generator";
import { Room, RoomType } from "../models";
import { documentExists } from "../helpers/check_existence";

const db = admin.firestore();

// function to add a room
export const addRoom = functions.https.onCall(async (request) => {
  const { roomData } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can add rooms."
    );
  }

  // Ensure the room data is provided
  if (!roomData.name || !roomData.type || !roomData.description ||
    !roomData.capacity || !roomData.building) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: name, type, description, capacity, building"
    );
  }

  // Ensure the room does not already exist
  if (await documentExists("rooms", "name", roomData.name)) {
    throw new functions.https.HttpsError(
      "already-exists",
      "A room with the same name already exists."
    );
  }

  // Ensure the room building is valid
  const buildingDoc = await admin
    .firestore()
    .collection("buildings")
    .doc(roomData.building)
    .get();

  if (!buildingDoc.exists) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid building"
    );
  }

  // Ensure the room type is valid
  if (!Object.values(RoomType).includes(roomData.type as RoomType)) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Invalid room type"
    );
  }

  try {


    // Generate a unique room ID
    const roomId = await generateId("RM", "rooms");

    // Prepare the room document
    const newRoom: Room = {
      id: roomId,
      name: roomData.name,
      type: roomData.type,
      description: roomData.description,
      capacity: roomData.capacity,
      building: roomData.building,
    };

    // Save the room document in Firestore
    await db.collection("rooms").doc(roomId).set(newRoom);

    return {
      message: "room added successfully!",
      success: true,
    };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error adding room",
      error
    );
  }
});

export const getRoom = functions.https.onCall(async (request) => {
  const { roomId } = request.data;

  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view rooms."
    );
  }

  // Check if the room id is provided
  if (!roomId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: roomId"
    );
  }
  // Fetch room data from Firestore
  const roomDoc = await admin
    .firestore()
    .collection("rooms")
    .doc(roomId)
    .get();

  if (!roomDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Room not found");
  }

  return roomDoc.data();
});

export const getAllRooms = functions.https.onCall(async (request) => {
  // Ensure only an admin can call this function
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can view rooms."
    );
  }

  try {
    // Fetch all rooms from Firestore
    const roomsSnapshot = await admin
      .firestore()
      .collection("rooms")
      .get();
    const roomsList: any[] = [];

    roomsSnapshot.forEach((doc) => {
      roomsList.push(doc.data());
    });

    return { rooms: roomsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching rooms data",
      error
    );
  }
});

export const updateRoom = functions.https.onCall(async (request) => {
  const { roomId, updateData } = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can update rooms."
    );
  }

  // Check if the room id and its updated data are provided
  if (!roomId || !updateData) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameters: roomId, updateData"
    );
  }

  const roomRef = db.collection("rooms").doc(roomId);
  const roomDoc = await roomRef.get();

  if (!roomDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Room not found");
  }

  try {

    // Use the updateData directly from the request
    await roomRef.update(updateData);

    return { message: "room updated successfully!", success: true };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error updating room data",
      error
    );
  }
});

export const deleteRoom = functions.https.onCall(async (request) => {
  const { roomId } = request.data;

  // Ensure the function is called by an admin user
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Only admins can delete rooms"
    );
  }

  // Check if the room id is povided
  if (!roomId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Missing required parameter: roomId"
    );
  }

  const roomDoc = await db.collection("rooms").doc(roomId).get();

  if (!roomDoc.exists) {
    throw new functions.https.HttpsError("not-found", "Room not found");
  }

  try {

    await deleteRoomAndUpdateActivities(roomDoc)
    return { message: "Room deleted successfully.", success: true };

  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error deleting room",
      error
    );
  }
});

export const getRoomsByBuilding = functions.https.onCall(async (request) => {
  const { buildingId } = request.data;

  // Ensure only admin can view them
  if (request.auth?.token.role !== "admin") {
    throw new functions.https.HttpsError(
      "permission-denied",
      "You do not have permission to view rooms."
    );
  }

  try {

    // Fetch provided building's rooms from Firestore
    const roomsSnapshot = await db
      .collection("rooms")
      .where("building", "==", buildingId)
      .get();

    const roomsList: any[] = [];

    roomsSnapshot.forEach((doc) => {
      roomsList.push(doc.data());
    });

    return { rooms: roomsList };
  } catch (error) {
    throw new functions.https.HttpsError(
      "internal",
      "Error fetching rooms data",
      error
    );
  }
});

export async function deleteRoomAndUpdateActivities(roomDoc: admin.firestore.DocumentSnapshot<admin.firestore.DocumentData, admin.firestore.DocumentData>): Promise<void> {

  const activitiesRef = db.collection("activities");

  await db.runTransaction(async (transaction) => {


    // Find all activities with the room reference
    const activitiesSnapshot = await activitiesRef
      .where("room", "==", roomDoc.data()?.id)
      .get();

    // Update each activity to set roomId to null
    activitiesSnapshot.forEach((activityDoc) => {
      transaction.update(activityDoc.ref, { room: null });
    });

    // Delete the room document
    transaction.delete(roomDoc.ref);
  });
}

export function getBasicRoomDetails(id: string) {
  const teacherDoc = db.collection("rooms").doc(id);
  return teacherDoc.get().then(doc => {
    if (!doc.exists) {
      throw new Error('Room not found');
    }
    return {
      id: doc.data()?.id, name: doc.data()?.name,
      type: doc.data()?.type, building: doc.data()?.building
    };
  });
}
