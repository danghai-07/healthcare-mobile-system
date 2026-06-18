import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../domain/entities/consultant.dart';
import '../../domain/repositories/consultant_repository.dart';
import 'consultant_view_status.dart';

/// MVP presenter for consultant discovery and profile viewing.
class ConsultantPresenter extends ChangeNotifier {
  ConsultantPresenter({
    required ConsultantRepository consultantRepository,
  }) : _consultantRepository = consultantRepository;

  final ConsultantRepository _consultantRepository;

  ConsultantViewStatus _listStatus = ConsultantViewStatus.idle;
  List<Consultant> _allConsultants = [];
  List<Consultant> _consultants = [];
  List<Specialty> _specialties = [];
  String _searchQuery = '';
  int? _selectedSpecialtyId;
  bool _availableOnly = false;
  DateTime _filterDate = DateTime.now();
  String? _listErrorMessage;

  ConsultantViewStatus _detailStatus = ConsultantViewStatus.idle;
  ConsultantDetail? _consultantDetail;
  String? _detailErrorMessage;

  ConsultantViewStatus get listStatus => _listStatus;
  List<Consultant> get consultants => _consultants;
  List<Specialty> get specialties => _specialties;
  String get searchQuery => _searchQuery;
  int? get selectedSpecialtyId => _selectedSpecialtyId;
  bool get availableOnly => _availableOnly;
  DateTime get filterDate => _filterDate;
  String? get listErrorMessage => _listErrorMessage;

  ConsultantViewStatus get detailStatus => _detailStatus;
  ConsultantDetail? get consultantDetail => _consultantDetail;
  String? get detailErrorMessage => _detailErrorMessage;

  bool get hasActiveFilters =>
      _searchQuery.isNotEmpty ||
      _selectedSpecialtyId != null ||
      _availableOnly;

  Future<void> loadConsultants() async {
    _listStatus = ConsultantViewStatus.loading;
    _listErrorMessage = null;
    notifyListeners();

    try {
      final results = _availableOnly
          ? await _consultantRepository.getAvailableConsultants(
              _dateOnly(_filterDate),
            )
          : await _consultantRepository.getAllConsultants();

      _allConsultants = results;
      _consultants = _applyClientFilters(_allConsultants);
      _listStatus = _consultants.isEmpty
          ? ConsultantViewStatus.empty
          : ConsultantViewStatus.success;
    } on ApiException catch (error) {
      _listErrorMessage = error.message;
      _listStatus = ConsultantViewStatus.error;
    } catch (_) {
      _listErrorMessage = 'Không thể tải danh sách tư vấn viên.';
      _listStatus = ConsultantViewStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadSpecialties() async {
    try {
      _specialties = await _consultantRepository.getAllSpecialties();
      notifyListeners();
    } catch (_) {
      // Non-blocking — filters degrade gracefully.
    }
  }

  Future<void> refreshList() => loadConsultants();

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _reapplyListFilters();
  }

  void setSpecialtyFilter(int? specialtyId) {
    _selectedSpecialtyId = specialtyId;
    _reapplyListFilters();
  }

  void setAvailableOnly(bool value) {
    if (_availableOnly == value) {
      return;
    }
    _availableOnly = value;
    loadConsultants();
  }

  void setFilterDate(DateTime date) {
    _filterDate = _dateOnly(date);
    if (_availableOnly) {
      loadConsultants();
    } else {
      notifyListeners();
    }
  }

  void clearFilters() {
    _searchQuery = '';
    _selectedSpecialtyId = null;
    _availableOnly = false;
    _filterDate = DateTime.now();
    loadConsultants();
  }

  Future<void> loadConsultantDetail(int consultantId) async {
    _detailStatus = ConsultantViewStatus.loading;
    _detailErrorMessage = null;
    notifyListeners();

    try {
      _consultantDetail =
          await _consultantRepository.getConsultantDetail(consultantId);
      _detailStatus = ConsultantViewStatus.success;
    } on ApiException catch (error) {
      _detailErrorMessage = error.message;
      _detailStatus = ConsultantViewStatus.error;
    } catch (_) {
      _detailErrorMessage = 'Không thể tải thông tin tư vấn viên.';
      _detailStatus = ConsultantViewStatus.error;
    }

    notifyListeners();
  }

  void _reapplyListFilters() {
    if (_listStatus == ConsultantViewStatus.loading) {
      return;
    }

    if (_availableOnly) {
      loadConsultants();
      return;
    }

    _consultants = _applyClientFilters(_allConsultants);
    _listStatus = _consultants.isEmpty
        ? ConsultantViewStatus.empty
        : ConsultantViewStatus.success;
    notifyListeners();
  }

  List<Consultant> _applyClientFilters(List<Consultant> source) {
    var results = source;

    if (_selectedSpecialtyId != null) {
      results = results
          .where(
            (c) => c.specialties.any((s) => s.id == _selectedSpecialtyId),
          )
          .toList();
    }

    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      results = results.where((c) {
        final nameMatch = c.fullName.toLowerCase().contains(query);
        final emailMatch = c.email.toLowerCase().contains(query);
        final specialtyMatch = c.specialties.any(
          (s) => (s.name ?? '').toLowerCase().contains(query),
        );
        return nameMatch || emailMatch || specialtyMatch;
      }).toList();
    }

    return results;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
