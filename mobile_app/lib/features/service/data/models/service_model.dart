import '../../domain/entities/medical_service.dart';
import '../dtos/service_dto.dart';
import '../dtos/test_service_record_dto.dart';

class ServiceModel {
  const ServiceModel._();

  static MedicalService fromDto(ServiceDto dto) => MedicalService(
        serviceId: dto.serviceId,
        name: dto.name,
        description: dto.description,
        price: dto.price,
      );
}

class TestServiceRecordModel {
  const TestServiceRecordModel._();

  static TestServiceRecord fromDto(TestServiceRecordDto dto) =>
      TestServiceRecord(
        testServiceRecordId: dto.testServiceRecordId,
        serviceId: dto.serviceId,
        serviceName: dto.serviceName,
        memberId: dto.memberId,
        staffId: dto.staffId,
        staffName: dto.staffName,
        recordDate: dto.recordDate,
        status: dto.status,
        dob: dto.dob,
        gender: dto.gender,
        phoneNumber: dto.phoneNumber,
        fullNameOfMember: dto.fullNameOfMember,
        result: dto.result,
        testDate: dto.testDate,
        timeSlot: dto.timeSlot,
        notes: dto.notes,
      );
}
