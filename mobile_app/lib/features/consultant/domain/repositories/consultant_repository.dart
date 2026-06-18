import '../entities/consultant.dart';

abstract interface class ConsultantRepository {
  Future<List<Consultant>> getAllConsultants();
  Future<List<Consultant>> getAvailableConsultants(DateTime date);
  Future<ConsultantDetail> getConsultantDetail(int id);
  Future<List<String>> getAvailableSlots(int consultantId, DateTime date);
  Future<List<Specialty>> getAllSpecialties();
  Future<Specialty?> getSpecialtyById(int id);
  Future<List<Specialty>> getSpecialtiesByUserId(int userId);
}
