/// Backend API endpoint paths from OpenAPI specification (exact casing).
abstract final class ApiEndpoints {
  // Auth
  static const String login = '/api/login';
  static const String register = '/api/register';
  static const String googleLogin = '/api/google-login';
  static const String otpSendByUserId = '/api/otp/sendOtpByUserId';
  static const String otpSendByEmail = '/api/otp/sendOtpByEmail';
  static const String otpVerify = '/api/otp/verify';

  // User / Profile
  static const String userGet = '/api/user/get';
  static const String userUpdate = '/api/user/update';
  static const String userChangePassword = '/api/user/change-password';
  static const String userResetPassword = '/api/user/reset-password';

  // Consultants
  static const String consultants = '/api/consultants';
  static const String consultantsAvailable = '/api/consultants/available';
  static const String consultantDetail = '/api/consultants';
  static const String consultantAvailableSlots = '/api/consultants';

  // Specialty
  static const String specialtyGetAll = '/api/specialty/getAll';
  static const String specialtyGetById = '/api/specialty/getById';
  static const String specialtyGetByUserId = '/api/specialty/getByUserID';

  // Schedule
  static const String scheduleWeek = '/api/schedule/week';

  // Appointments
  static const String appointmentCreate = '/api/Appointment/create';
  static const String appointmentList = '/api/Appointment/list';
  static const String appointmentDetail = '/api/Appointment/detail';
  static const String appointmentByMember = '/api/Appointment/member';
  static const String appointmentByConsultant = '/api/Appointment/consultant';
  static const String appointmentUpdateStatus = '/api/Appointment/update-status';
  static const String appointmentUpdateMeetLink = '/api/Appointment/update-meetlink';

  // Services & test records
  static const String services = '/api/Service';
  static const String testServiceRecordBook = '/api/TestServiceRecord/book';
  static const String testServiceRecordByMember = '/api/TestServiceRecord/member';
  static const String testServiceRecordDetail = '/api/TestServiceRecord';
  static const String testServiceRecordCancel = '/api/TestServiceRecord/cancel';
  static const String testServiceRecordWorkShifts = '/api/TestServiceRecord/work-shifts';
  static const String testServiceRecordAvailableStaff = '/api/TestServiceRecord/available-staff';

  // Blogs
  static const String blogs = '/api/blogs';
  static const String blogsPopular = '/api/blogs/popular';
  static const String blogsByTopic = '/api/blogs/topic';
  static const String blogsByTitle = '/api/blogs/title';
}
