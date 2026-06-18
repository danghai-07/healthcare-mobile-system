/// View status for appointment flows.
enum AppointmentViewStatus {
  idle,
  loading,
  success,
  empty,
  error,
}

/// Filter for appointment history list.
enum AppointmentHistoryFilter {
  all,
  upcoming,
  past,
}

/// Top-level tabs on the appointments screen.
enum AppointmentListTab {
  consultations,
  testRecords,
}
