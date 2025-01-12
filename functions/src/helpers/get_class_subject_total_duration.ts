import * as admin from "firebase-admin";

const db = admin.firestore();

export const totalDuration = async (classId: string, subjectId: String): Promise<number> => {
  try {
    let totalDuration = 0;

    const activitiesSnapshot = await db
      .collection("activities")
      .where("studentsClass", "==", classId)
      .where("subject", "==", subjectId)
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
