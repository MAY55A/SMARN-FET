import * as admin from "firebase-admin";

// Initialisation Firebase
admin.initializeApp();

// Importation des fonctions depuis différents modules
import {
  createTeacherAccount,
  updateTeacherAccount,
  getTeacher,
  getAllTeachers,
  deleteTeacherAccount,
  getTeachersBySubject,
  updateTeacherSubjects,
  getAllTeachersNames,
  getTeacherName,
} from "./functions/teacher_functions";

import {
  addClass,
  deleteClass,
  getAllClasses,
  getAllClassesNames,
  getAllClassesNbStudents,
  getClass,
  regenerateClassKey,
  updateClass,
} from "./functions/class_functions";

import {
  addRoom,
  deleteRoom,
  getAllRooms,
  getRoom,
  getRoomsByBuilding,
  updateRoom,
} from "./functions/room_functions";

import {
  addBuilding,
  getBuilding,
  getAllBuildings,
  updateBuilding,
  deleteBuilding,
} from "./functions/building_functions";

import {
  addSubject,
  updateSubject,
  getSubject,
  getAllSubjects,
  deleteSubject,
} from "./functions/subject_functions";

import {
  createChangeRequest,
  updateChangeRequest,
  getChangeRequest,
  getAllChangeRequests,
  deleteChangeRequest,
  getChangeRequestsByTeacher,
} from "./functions/change_request_functions";

import {
  addActivity,
  updateActivity,
  getActivity,
  getAllActivities,
  getActivitiesByTeacher,
  getActivitiesByClass,
  deleteActivity,
} from "./functions/activity_functions";

import {
  createSchedulingRule,
  createSpaceConstraint,
  createTimeConstraint,
  deleteConstraint,
  getActiveConstraints,
  getActiveConstraintsByCategory,
  getAllConstraints,
  getConstraintsByCategory,
  getMinMaxDuration,
  updateConstraint,
} from "./functions/constraint_functions";

import {
  createSchedules,
  getSchedule,
  getSchedulesForType,
  updateSchedule,
} from "./functions/schedule_functions";

// Exportation des fonctions pour utilisation dans Firebase
export {
  createTeacherAccount,
  updateTeacherAccount,
  updateTeacherSubjects,
  getTeacherName,
  getTeacher,
  getAllTeachers,
  deleteTeacherAccount,
  getTeachersBySubject,
  getAllTeachersNames,
};

export {
  addClass,
  updateClass,
  regenerateClassKey,
  getAllClassesNames,
  getAllClassesNbStudents,
  getClass,
  getAllClasses,
  deleteClass,
};

export { addSubject, updateSubject, getSubject, getAllSubjects, deleteSubject };

export {
  addRoom,
  updateRoom,
  getRoom,
  getRoomsByBuilding,
  getAllRooms,
  deleteRoom,
};

export {
  addBuilding,
  updateBuilding,
  getBuilding,
  getAllBuildings,
  deleteBuilding,
};

export {
  createChangeRequest,
  updateChangeRequest,
  getChangeRequest,
  getAllChangeRequests,
  getChangeRequestsByTeacher,
  deleteChangeRequest,
};

export {
  addActivity,
  updateActivity,
  getActivity,
  getAllActivities,
  getActivitiesByTeacher,
  getActivitiesByClass,
  deleteActivity,
};

export {
  createTimeConstraint,
  createSpaceConstraint,
  createSchedulingRule,
  getAllConstraints,
  getConstraintsByCategory,
  getActiveConstraints,
  getActiveConstraintsByCategory,
  updateConstraint,
  deleteConstraint,
  getMinMaxDuration,
};

export {
  createSchedules,
  getSchedule,
  getSchedulesForType,
  updateSchedule,
};
