class WorkShift {
  const WorkShift({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    this.currentBookings = 0,
    this.maxBookings = 0,
    this.isAvailable = true,
    this.status,
  });

  final int shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final int currentBookings;
  final int maxBookings;
  final bool isAvailable;
  final String? status;

  String get displayLabel => '$shiftName ($startTime – $endTime)';
}
