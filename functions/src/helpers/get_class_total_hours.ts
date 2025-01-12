import * as admin from "firebase-admin";

const db = admin.firestore();

export const totalActivitiesDuration = async (classId: string): Promise<number> => {
  try {

    let totalDuration = 0;
    const activitiesSnapshot = await db
      .collection("activities")
      .where("studentsClass", "==", classId)
      .get();

    if (activitiesSnapshot.empty) {
      return totalDuration;
    }

    activitiesSnapshot.forEach((doc) => {
      const activity = doc.data();
      if (activity.duration) {
        totalDuration += activity.duration;
      }
    });

    return totalDuration;
  } catch (error) {
    console.error("Error fetching activities:", error);
    throw new Error("Failed to calculate the sum of durations");
  }
};
