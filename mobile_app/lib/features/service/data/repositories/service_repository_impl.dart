import '../../domain/entities/medical_service.dart';
import '../../domain/entities/work_shift.dart';
import '../../domain/repositories/service_repository.dart';
import '../dtos/book_test_service_record_dto.dart';
import '../models/service_model.dart';
import '../services/service_api_service.dart';

class ServiceRepositoryImpl implements ServiceRepository {
  ServiceRepositoryImpl(this._apiService);

  final ServiceApiService _apiService;

  @override
  Future<List<MedicalService>> getAllServices() async {
    final dtos = await _apiService.getAllServices();
    return dtos.map(ServiceModel.fromDto).toList();
  }

  @override
  Future<MedicalService> getServiceById(int serviceId) async {
    final dto = await _apiService.getServiceById(serviceId);
    return ServiceModel.fromDto(dto);
  }

  @override
  Future<int> bookTestService(BookTestServiceRequest request) {
    final dto = BookTestServiceRecordDto(
      serviceId: request.serviceId,
      fullName: request.fullName,
      dob: request.dob,
      gender: request.gender,
      phoneNumber: request.phoneNumber,
      testDate: request.testDate,
      userId: request.userId,
      shift: request.shift,
    );
    return _apiService.bookTestService(dto);
  }

  @override
  Future<List<TestServiceRecord>> getRecordsByMember(int memberId) async {
    final dtos = await _apiService.getRecordsByMember(memberId);
    return dtos.map(TestServiceRecordModel.fromDto).toList();
  }

  @override
  Future<TestServiceRecord> getRecordDetail(
    int testServiceRecordId,
    int memberId,
  ) async {
    final dto = await _apiService.getRecordDetail(testServiceRecordId, memberId);
    return TestServiceRecordModel.fromDto(dto);
  }

  @override
  Future<void> cancelRecord(int testServiceRecordId, int userId) =>
      _apiService.cancelRecord(testServiceRecordId, userId);

  @override
  Future<List<WorkShift>> getWorkShifts(DateTime date) async {
    final dtos = await _apiService.getWorkShifts(date);
    return dtos.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<dynamic>> getAvailableStaff(DateTime date) =>
      _apiService.getAvailableStaff(date);
}
