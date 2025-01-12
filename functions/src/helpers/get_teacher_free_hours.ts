import * as admin from "firebase-admin";

const db = admin.firestore();

export const freeTime = async (teacherId: string): Promise<number> => {
  try {
    const teacherSnapshot = await db.collection("teachers").where("id", "==", teacherId).get();
    const maxDuration = teacherSnapshot.docs[0].data().nbHours * 60;

    const activitiesSnapshot = await db
      .collection("activities")
      .where("teacher", "==", teacherId)
      .get();

    if (activitiesSnapshot.empty) {
      return maxDuration;
    }

    let totalDuration = 0;

    activitiesSnapshot.forEach((doc) => {
      const activity = doc.data();
      if (activity.duration) {
        totalDuration += activity.duration;
      }
    });

    return maxDuration - totalDuration;
  } catch (error) {
    console.error("Error fetching activities:", error);
    throw new Error("Failed to calculate the sum of durations");
  }
};
