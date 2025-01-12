import * as admin from "firebase-admin";

const db = admin.firestore();

// Function to check if a document exists in Firestore
export const documentExists = async (collection: string, field: string
  , value: string): Promise<boolean> => {
  try {
    const querySnapshot = await db.collection(collection)
      .where(field, "==", value)
      .limit(1)
      .get();

    return !querySnapshot.empty;
  } catch (error) {
    console.error("Error checking document existence:", error);
    throw error;
  }
};
