import * as admin from "firebase-admin";

// Initialize Firebase Admin SDK
const firestore = admin.firestore();

// Function to generate a unique ID
export const generateId = async (prefix: string, collectionName: string): Promise<string> => {
  try {
    const counterDocRef = firestore.collection("metadata").doc(`${collectionName}Counter`);

    // Use a Firestore transaction to safely increment the counter and generate a unique ID
    const id = await firestore.runTransaction(async (transaction) => {
      const snapshot = await transaction.get(counterDocRef);

      // If the document does not exist, initialize it
      if (!snapshot.exists) {
        console.log("Document doesn't exist, creating new counter...");
        transaction.set(counterDocRef, {count: 0}); // Initialize the counter to 0
        return prefix + "001"; // Return the first ID with padded number
      }

      // Retrieve current count and increment it
      const currentCount = snapshot.data()?.count ?? 0;
      const newCount = currentCount + 1;

      // Update the counter document with the new count
      transaction.update(counterDocRef, {count: newCount});

      // Return the newly generated ID with the prefix
      return prefix + newCount.toString().padStart(4, "0");
    });

    return id; // Return the generated ID
  } catch (error) {
    console.error("Error generating custom ID: ", error);
    throw new Error("Error generating custom ID");
  }
};
