import 'package:smarn/models/activity.dart';

class Schedule {
  String? id;
  String
      belongsTo; // the teacher, class, room, or subject id to whome this schedule belongs
  List<Activity> activities;
  String? creationDate;
  String? logs;

  Schedule(
      {this.id,
      required this.belongsTo,
      required this.activities,
      this.creationDate,
      this.logs});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'belongsTo': belongsTo,
      'activities': activities.map((activity) => activity.toMap()).toList(),
      'creationDate': creationDate,
      'logs': logs,
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id'],
      belongsTo: map['belongsTo'],
      activities: map['activities']
          .map((activityMap) => Activity.fromMap(activityMap))
          .toList(),
      creationDate: map['creationDate'],
      logs: map['logs'],
    );
  }
}
