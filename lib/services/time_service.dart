class TimeService {
// Helper function to convert "HH:MM" to minutes
  static int timeToMinutes(String time) {
    final parts = time.split(':').map(int.parse).toList();
    return parts[0] * 60 + parts[1];
  }
  // Helper function to add minutes to a given time
  static String addMinutesToTime(String time, int minutesToAdd) {
    final totalMinutes = timeToMinutes(time) + minutesToAdd;
    return minutesToTime(totalMinutes);
  }


// Helper function to convert minutes back to "HH:MM"
  static String minutesToTime(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

// Helper function to return list of hours based on given time range and duration
  static Map<String, List<String>> generateHours(
      String start, String end, int durationMinutes) {
    final startTimes = <String>[];
    final endTimes = <String>[];

    final startMinutes = timeToMinutes(start);
    final endMinutes = timeToMinutes(end);
    for (var current = startMinutes;
        current + durationMinutes <= endMinutes;
        current += durationMinutes) {
      startTimes.add(minutesToTime(current));
      endTimes.add(minutesToTime(current + durationMinutes));
    }

    return {"startTimes": startTimes, "endTimes": endTimes};
  }
}
