import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";

export const setAdminRole = functions.https.onCall(async (request) => {
  const {uid} = request.data; // User ID to assign the admin role

  // Ensure that the function is called by an authenticated admin

  if (!request.auth || request.auth.token.role !== "admin") {
    throw new functions.https.HttpsError("permission-denied", "Only admins can assign roles");
  }

  if (!uid) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "User ID is required"
    );
  }

  try {
    // Set custom claims to grant the user an "admin" role
    await admin.auth().setCustomUserClaims(uid, {role: "admin"});

    // Optional: Return a success message
    return {message: `User with UID ${uid} has been granted the admin role`};
  } catch (error) {
    console.error("Error setting admin role:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Failed to set admin role",
      error
    );
  }
});
