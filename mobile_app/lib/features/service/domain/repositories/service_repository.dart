import '../entities/medical_service.dart';

import '../entities/work_shift.dart';

abstract interface class ServiceRepository {
  Future<List<MedicalService>> getAllServices();
  Future<MedicalService> getServiceById(int serviceId);
  Future<int> bookTestService(BookTestServiceRequest request);
  Future<List<TestServiceRecord>> getRecordsByMember(int memberId);
  Future<TestServiceRecord> getRecordDetail(int testServiceRecordId, int memberId);
  Future<void> cancelRecord(int testServiceRecordId, int userId);
  Future<List<WorkShift>> getWorkShifts(DateTime date);
  Future<List<dynamic>> getAvailableStaff(DateTime date);
}
