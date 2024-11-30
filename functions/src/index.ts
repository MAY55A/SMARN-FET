import * as admin from "firebase-admin";

admin.initializeApp();

// import {setAdminRole} from "./functions/admin_functions";
import {createTeacherAccount, updateTeacherAccount,
  getTeacher, getAllTeachers, deleteTeacherAccount,
  getTeachersBySubject,
  updateTeacherSubjects,
  getAllTeachersNames,
  getTeacherName} from "./functions/teacher_functions";
import {addClass, deleteClass, getAllClasses, getAllClassesNames, getClass,
  regenerateClassKey, updateClass} from "./functions/class_functions";
import {addRoom, deleteRoom, getAllRooms, getRoom,
  getRoomsByBuilding,
  updateRoom} from "./functions/room_functions";
import {addBuilding, getBuilding, getAllBuildings,
  updateBuilding, deleteBuilding} from "./functions/building_functions";
import {addSubject, updateSubject, getSubject, getAllSubjects,
  deleteSubject} from "./functions/subject_functions";
import {createChangeRequest, updateChangeRequest, getChangeRequest,
  getAllChangeRequests, deleteChangeRequest,
  getChangeRequestsByTeacher} from "./functions/change_request_functions";
import {addActivity, updateActivity, getActivity, getAllActivities,
  getActivitiesByTeacher, getActivitiesByClass, deleteActivity} from "./functions/activity_functions";


// export {setAdminRole};
export {createTeacherAccount, updateTeacherAccount, updateTeacherSubjects, getTeacherName,
  getTeacher, getAllTeachers, deleteTeacherAccount, getTeachersBySubject, getAllTeachersNames};
export {addClass, updateClass, regenerateClassKey, getAllClassesNames,
  getClass, getAllClasses, deleteClass};
export {addSubject, updateSubject, getSubject,
  getAllSubjects, deleteSubject};
export {addRoom, updateRoom, getRoom, getRoomsByBuilding,
  getAllRooms, deleteRoom};
export {addBuilding, updateBuilding, getBuilding,
  getAllBuildings, deleteBuilding};
export {createChangeRequest, updateChangeRequest, getChangeRequest,
  getAllChangeRequests, getChangeRequestsByTeacher, deleteChangeRequest};
export {addActivity, updateActivity, getActivity, getAllActivities,
  getActivitiesByTeacher, getActivitiesByClass, deleteActivity};
