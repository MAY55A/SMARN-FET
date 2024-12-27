import 'package:smarn/models/activity_tag.dart';
import 'package:smarn/models/room_type.dart';
import 'package:smarn/models/work_day.dart';

abstract class Constraint {
  final String? id;
  final ConstraintCategory category;
  final bool isActive;

  Constraint({
    this.id,
    required this.category,
    this.isActive = true,
  });

  Map<String, dynamic> toMap() {
    if (category == ConstraintCategory.timeConstraint) {
      return (this as TimeConstraint).toMap();
    } else if (category == ConstraintCategory.spaceConstraint) {
      return (this as SpaceConstraint).toMap();
    } else {
      return (this as SchedulingRule).toMap();
    }
  }

  factory Constraint.fromMap(Map<String, dynamic> map) {
    final ConstraintCategory category = ConstraintCategory.values.firstWhere(
      (element) => element.name == map['category'],
    );
    if (category == ConstraintCategory.timeConstraint) {
      return TimeConstraint.fromMap(map);
    } else if (category == ConstraintCategory.spaceConstraint) {
      return SpaceConstraint.fromMap(map);
    } else {
      return SchedulingRule.fromMap(map);
    }
  }

  @override
  String toString() {
    return 'Constraint: $id, Category: $category, Active: $isActive';
  }
}

class TimeConstraint extends Constraint {
  final TimeConstraintType type;
  final String? startTime;
  final String? endTime;
  final List<WorkDay> availableDays;
  final String? teacherId;
  final String? classId;
  final String? roomId;

  TimeConstraint({
    super.id,
    required this.type,
    this.startTime,
    this.endTime,
    required this.availableDays,
    this.teacherId,
    this.classId,
    this.roomId,
    super.isActive,
  }) : super(category: ConstraintCategory.timeConstraint);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.name,
      'isActive': isActive,
      'type': type.name,
      'startTime': startTime,
      'endTime': endTime,
      'availableDays': availableDays.map((day) => day.name).toList(),
      'teacherId': teacherId,
      'classId': classId,
      'roomId': roomId,
    };
  }

  factory TimeConstraint.fromMap(Map<String, dynamic> map) {
    return TimeConstraint(
      id: map['id'],
      type: TimeConstraintType.values
          .firstWhere((type) => type.name == map['type']),
      startTime: map['startTime'],
      endTime: map['endTime'],
      availableDays: map['availableDays']
          .map<WorkDay>((dayName) =>
              WorkDay.values.firstWhere((day) => day.name == dayName))
          .toList(),
      teacherId: map['teacherId'],
      classId: map['classId'],
      roomId: map['roomId'],
      isActive: map['isActive'],
    );
  }

  @override
  String toString() {
    return '${super.toString()}, Type: ${type.name}, Start Time: $startTime, End Time: $endTime, Available Days: ${availableDays.join(', ')}, Teacher ID: $teacherId, Class ID: $classId, Room ID: $roomId';
  }

}

class SpaceConstraint extends Constraint {
  final SpaceConstraintType type;
  final ActivityTag? activityType;
  final String? roomId;
  final String? teacherId;
  final String? classId;
  final String? subjectId;
  final RoomType? requiredRoomType;

  SpaceConstraint({
    super.id,
    required this.type,
    this.activityType,
    this.teacherId,
    this.classId,
    this.subjectId,
    this.roomId,
    this.requiredRoomType,
    super.isActive,
  }) : super(category: ConstraintCategory.spaceConstraint);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.name,
      'isActive': isActive,
      'type': type.name,
      'activityType': activityType?.name,
      'teacherId': teacherId,
      'classId': classId,
      'roomId': roomId,
      'subjectId': subjectId,
      'requiredRoomType': requiredRoomType?.name,
    };
  }

  factory SpaceConstraint.fromMap(Map<String, dynamic> map) {
    return SpaceConstraint(
      id: map['id'],
      type: SpaceConstraintType.values
          .firstWhere((type) => type.name == map['type']),
      activityType: map['activityType']?.let((activityTypeName) => ActivityTag
          .values
          .firstWhere((activityType) => activityType.name == activityTypeName)),
      teacherId: map['teacherId'],
      classId: map['classId'],
      subjectId: map['subjectId'],
      roomId: map['roomId'],
      requiredRoomType: map['requiredRoomType']?.let((roomTypeName) => RoomType
          .values
          .firstWhere((roomType) => roomType.name == roomTypeName)),
      isActive: map['isActive'],
    );
  }

  @override
  String toString() {
    return '${super.toString()}, Activity Type: ${activityType?.name}, Room ID: $roomId, Teacher ID: $teacherId, Class ID: $classId, Subject ID: $subjectId, Required Room Type : ${requiredRoomType?.name}';
  }

}

class SchedulingRule extends Constraint {
  final SchedulingRuleType type;
  final int? duration;
  final String? startTime;
  final String? endTime;
  final List<WorkDay>? applicableDays;

  SchedulingRule({
    super.id,
    required this.type,
    this.duration,
    this.startTime,
    this.endTime,
    this.applicableDays,
    super.isActive,
  }) : super(category: ConstraintCategory.schedulingRule);

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category.name,
      'isActive': isActive,
      'type': type.name,
      'duration': duration,
      'startTime': startTime,
      'endTime': endTime,
      'applicableDays': applicableDays?.map((day) => day.name).toList(),
    };
  }

  factory SchedulingRule.fromMap(Map<String, dynamic> map) {
    return SchedulingRule(
      id: map['id'],
      type: SchedulingRuleType.values
          .firstWhere((type) => type.name == map['type']),
      duration: map['duration'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      applicableDays: map['applicableDays']
          ?.map<WorkDay>((dayName) =>
              WorkDay.values.firstWhere((day) => day.name == dayName))
          .toList(),
      isActive: map['isActive'],
    );
  }

  @override
  String toString() {
    return '${super.toString()}, Duration: $duration, Start Time: $startTime, End Time: $endTime, Applicable Days: ${applicableDays?.join(', ')}';
  }
}

enum ConstraintCategory { timeConstraint, spaceConstraint, schedulingRule }

enum TimeConstraintType {
  teacherAvailability,
  classAvailability,
  roomAvailability,
}

enum SpaceConstraintType { roomType, preferredRoom }

enum SchedulingRuleType {
  workPeriod,
  breakPeriod,
  minActivityDuration,
}
