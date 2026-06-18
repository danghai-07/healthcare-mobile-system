import '../../domain/entities/consultant.dart';
import '../../domain/repositories/consultant_repository.dart';
import '../models/consultant_model.dart';
import '../services/consultant_api_service.dart';

class ConsultantRepositoryImpl implements ConsultantRepository {
  ConsultantRepositoryImpl(this._apiService);

  final ConsultantApiService _apiService;

  @override
  Future<List<Consultant>> getAllConsultants() async {
    final dtos = await _apiService.getAllConsultants();
    return dtos.map(ConsultantModel.fromDto).toList();
  }

  @override
  Future<List<Consultant>> getAvailableConsultants(DateTime date) async {
    final dtos = await _apiService.getAvailableConsultants(date);
    return dtos.map(ConsultantModel.fromDto).toList();
  }

  @override
  Future<ConsultantDetail> getConsultantDetail(int id) async {
    final dto = await _apiService.getConsultantDetail(id);
    return ConsultantModel.fromDetailDto(dto);
  }

  @override
  Future<List<String>> getAvailableSlots(int consultantId, DateTime date) =>
      _apiService.getAvailableSlots(consultantId, date);

  @override
  Future<List<Specialty>> getAllSpecialties() async {
    final dtos = await _apiService.getAllSpecialties();
    return dtos.map(SpecialtyModel.fromDto).toList();
  }

  @override
  Future<Specialty?> getSpecialtyById(int id) async {
    final dto = await _apiService.getSpecialtyById(id);
    return SpecialtyModel.fromDto(dto);
  }

  @override
  Future<List<Specialty>> getSpecialtiesByUserId(int userId) async {
    final dtos = await _apiService.getSpecialtiesByUserId(userId);
    return dtos.map(SpecialtyModel.fromDto).toList();
  }
}
