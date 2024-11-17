import * as admin from "firebase-admin";

const db = admin.firestore();

// Function to check if a document exists in Firestore
export const freeHours = async (teacherId: string): Promise<number> => {
    try {
        const teacherDoc = await db.collection("teachers").doc(teacherId).get();
        const targetHours = teacherDoc.data()?.nbHours;

        const activitiesSnapshot = await db
            .collection("activities")
            .where("teacher", "==", teacherId)
            .get();

        if (activitiesSnapshot.empty) {
            return targetHours;
        }

        let totalDuration = 0;

        activitiesSnapshot.forEach((doc) => {
            const activity = doc.data();
            if (activity.duration) {
                totalDuration += activity.duration;
            }
        });

        return targetHours - totalDuration;
    } catch (error) {
        console.error("Error fetching activities:", error);
        throw new Error("Failed to calculate the sum of durations");
    }
}