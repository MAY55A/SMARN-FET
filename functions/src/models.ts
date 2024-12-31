export interface Teacher {
    id: string;
    name: string;
    email: string;
    phone: string;
    picture?: string;
    nbHours: number;
    subjects: string[];
}

export interface Subject {
    id: string;
    name: string;
    longName: string;
    description: string;
}

export interface Class {
    id: string;
    name: string;
    longName: string;
    accessKey: string;
    nbStudents: number;
}

export interface Room {
    id: string;
    name: string;
    type: RoomType;
    description: string;
    capacity: number;
    building: string;
}

export enum RoomType {
    lecture = "lecture",
    lab = "lab",
    seminar = "seminar",
    auditorium = "auditorium",
    other = "other"
}

export interface Building {
    id: string;
    name: string;
    longName: string;
    description: string;
}

export interface Activity {
    id: string;
    subject: string;
    teacher: string;
    studentsClass: string;
    tag: ActivityTag;
    isActive: boolean;
    duration: number;
    day?: WorkDay;
    startTime?: string;
    endTime?: string;
    room?: string;
}

export enum WorkDay {
    MONDAY = "Monday",
    TUESDAY = "Tuesday",
    WEDNESDAY = "Wednesday",
    THURSDAY = "Thursday",
    FRIDAY = "Friday",
    SATURDAY = "Saturday",
}

export enum ActivityTag {
    lecture = "lecture",
    lab = "lab",
    seminar = "seminar",
    workshop = "workshop",
    exam = "exam",
    other = "other"
}

export interface ChangeRequest {
    id: string;
    newTimeSlot?: string;
    newRoom?: string;
    activity?: string;
    reason: string;
    content: string;
    teacher: string;
    submissionDate?: string;
    status: ChangeRequestStatus;
}

export enum ChangeRequestStatus {
    pending = "pending",
    approved = "approved",
    rejected = "rejected",
}

export interface Constraint {
    id: string;
    category: ConstraintCategory;
    isActive: boolean;
}

export interface TimeConstraint extends Constraint {
    type: TimeConstraintType;
    startTime: String;
    endTime: String;
    availableDays: WorkDay[];
    teacherId?: String;
    classId?: String;
}

export interface SpaceConstraint extends Constraint {
    type: SpaceConstraintType;
    roomId?: String;
    subjectId?: String;
    activityType?: ActivityTag;
    requiredRoomType?: RoomType;
    teacherId?: String;
    classId?: String;
}

export interface SchedulingRule extends Constraint {
    type: SchedulingRuleType;
    startTime?: String;
    endTime?: String;
    applicableDays?: WorkDay[];
    duration?: number;
}

export enum ConstraintCategory {
    timeConstraint = "timeConstraint",
    spaceConstraint = "spaceConstraint",
    schedulingRule = "schedulingRule",
}


export enum TimeConstraintType {
    teacherAvailability = "teacherAvailability",
    classAvailability = "classAvailability",
    roomAvailability = "roomAvailability",
}

export enum SpaceConstraintType {
    roomType = "roomType",
    preferredRoom = "preferredRoom",
}

export enum SchedulingRuleType {
    workPeriod = "workPeriod",
    breakPeriod = "breakPeriod",
    minActivityDuration = "minActivityDuration",
}
