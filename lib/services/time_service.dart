class TimeService {
// Helper function to convert "HH:MM" to minutes
  static int timeToMinutes(String time) {
    final parts = time.split(':').map(int.parse).toList();
    return parts[0] * 60 + parts[1];
  }

// Helper function to convert minutes back to "HH:MM"
  static String minutesToTime(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

// Helper function to return list of hours based on given time range and duration
  static List<String> generateHours(
      String start, String end, int durationMinutes) {
    final result = <String>[];

    final startMinutes = timeToMinutes(start);
    final endMinutes = timeToMinutes(end);

    for (var current = startMinutes;
        current + durationMinutes <= endMinutes;
        current += durationMinutes) {
      final startTime = minutesToTime(current);
      final endTime = minutesToTime(current + durationMinutes);
      result.add('$startTime - $endTime');
    }

    return result;
  }
}
