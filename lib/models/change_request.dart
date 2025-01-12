import 'change_request_status.dart';

class ChangeRequest {
  String? id;
  String? newTimeSlot;
  String? newRoom;
  String? activity;
  String reason;
  String content;
  String teacher;
  String? submissionDate;
  ChangeRequestStatus? status;

  // Constructor
  ChangeRequest({
    this.id,
    this.newTimeSlot,
    this.newRoom,
    this.activity,
    required this.reason,
    required this.content,
    required this.teacher,
    this.submissionDate,
    this.status,
  });

  // Convert a ChangeRequest object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'newTimeSlot': newTimeSlot,
      'newRoom': newRoom,
      'activity': activity,
      'reason': reason,
      'content': content,
      'teacher': teacher,
      'submissionDate': submissionDate,
      'status': status?.name,
    };
  }

  // Create a ChangeRequest object from a Map
  factory ChangeRequest.fromMap(Map<String, dynamic> map) {
    return ChangeRequest(
      id: map['id'],
      newTimeSlot: map['newTimeSlot'],
      newRoom: map['newRoom'],
      activity: map['activity'],
      reason: map['reason'],
      content: map['content'],
      teacher: map['teacher'],
      submissionDate: map['submissionDate'],
      status: ChangeRequestStatus.values
          .firstWhere((status) => status.name == map['status']),
    );
  }

  bool equals(ChangeRequest other) {
    return other.id == id &&
        other.newTimeSlot == newTimeSlot &&
        other.newRoom == newRoom &&
        other.activity == activity &&
        other.reason == reason &&
        other.content == content;
  }

  @override
  String toString() {
    return 'ChangeRequest{\nid: $id,\n newTimeSlot: $newTimeSlot,\n newRoom: $newRoom,\n activity: $activity,\n reason: $reason,\n content: $content,\n teacher: $teacher,\n submissionDate: $submissionDate,\n status: $status\n}';
  }
}
