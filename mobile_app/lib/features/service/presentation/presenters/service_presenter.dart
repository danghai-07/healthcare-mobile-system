import 'package:flutter/foundation.dart';

import '../../../appointment/presentation/presenters/appointment_view_status.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/session_helper.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/validation/auth_validation.dart';
import '../../domain/entities/medical_service.dart';
import '../../domain/entities/work_shift.dart';
import '../../domain/repositories/service_repository.dart';
import '../validation/service_validation.dart';
import 'service_view_status.dart';

/// MVP presenter for medical test services, booking, and records.
class ServicePresenter extends ChangeNotifier {
  ServicePresenter({
    required ServiceRepository serviceRepository,
    required AuthRepository authRepository,
  })  : _serviceRepository = serviceRepository,
        _authRepository = authRepository;

  final ServiceRepository _serviceRepository;
  final AuthRepository _authRepository;

  // ─── Service list ─────────────────────────────────────────────────────────
  ServiceViewStatus _listStatus = ServiceViewStatus.idle;
  List<MedicalService> _allServices = [];
  List<MedicalService> _services = [];
  String _searchQuery = '';
  String? _listErrorMessage;

  // ─── Service detail ───────────────────────────────────────────────────────
  ServiceViewStatus _detailStatus = ServiceViewStatus.idle;
  MedicalService? _serviceDetail;
  String? _detailErrorMessage;

  // ─── Booking ──────────────────────────────────────────────────────────────
  ServiceViewStatus _bookingInitStatus = ServiceViewStatus.idle;
  ServiceViewStatus _shiftsStatus = ServiceViewStatus.idle;
  int? _bookingServiceId;
  MedicalService? _bookingService;
  String? _bookingInitErrorMessage;

  DateTime? _dateOfBirth;
  DateTime _testDate = DateTime.now();
  List<WorkShift> _workShifts = [];
  int? _selectedShiftId;
  String _fullName = '';
  String? _gender;
  String _phoneNumber = '';
  bool _isBooking = false;
  String? _bookingErrorMessage;
  int? _lastBookedRecordId;

  String? _fullNameError;
  String? _genderError;
  String? _phoneError;
  String? _dobError;
  String? _testDateError;
  String? _shiftError;

  // ─── Test records ─────────────────────────────────────────────────────────
  ServiceViewStatus _recordsStatus = ServiceViewStatus.idle;
  List<TestServiceRecord> _allTestRecords = [];
  List<TestServiceRecord> _testRecords = [];
  AppointmentHistoryFilter _testRecordFilter = AppointmentHistoryFilter.all;
  String? _recordsErrorMessage;

  ServiceViewStatus _recordDetailStatus = ServiceViewStatus.idle;
  TestServiceRecord? _testRecordDetail;
  String? _recordDetailErrorMessage;
  bool _isCancelling = false;

  // ─── Getters ──────────────────────────────────────────────────────────────
  ServiceViewStatus get listStatus => _listStatus;
  List<MedicalService> get services => _services;
  String get searchQuery => _searchQuery;
  String? get listErrorMessage => _listErrorMessage;

  ServiceViewStatus get detailStatus => _detailStatus;
  MedicalService? get serviceDetail => _serviceDetail;
  String? get detailErrorMessage => _detailErrorMessage;

  ServiceViewStatus get bookingInitStatus => _bookingInitStatus;
  ServiceViewStatus get shiftsStatus => _shiftsStatus;
  MedicalService? get bookingService => _bookingService;
  String? get bookingInitErrorMessage => _bookingInitErrorMessage;
  DateTime? get dateOfBirth => _dateOfBirth;
  DateTime get testDate => _testDate;
  List<WorkShift> get workShifts => _workShifts;
  int? get selectedShiftId => _selectedShiftId;
  String get fullName => _fullName;
  String? get gender => _gender;
  String get phoneNumber => _phoneNumber;
  bool get isBooking => _isBooking;
  String? get bookingErrorMessage => _bookingErrorMessage;
  int? get lastBookedRecordId => _lastBookedRecordId;
  String? get fullNameError => _fullNameError;
  String? get genderError => _genderError;
  String? get phoneError => _phoneError;
  String? get dobError => _dobError;
  String? get testDateError => _testDateError;
  String? get shiftError => _shiftError;

  ServiceViewStatus get recordsStatus => _recordsStatus;
  List<TestServiceRecord> get testRecords => _testRecords;
  AppointmentHistoryFilter get testRecordFilter => _testRecordFilter;
  String? get recordsErrorMessage => _recordsErrorMessage;

  ServiceViewStatus get recordDetailStatus => _recordDetailStatus;
  TestServiceRecord? get testRecordDetail => _testRecordDetail;
  String? get recordDetailErrorMessage => _recordDetailErrorMessage;
  bool get isCancelling => _isCancelling;

  // ─── Service list ─────────────────────────────────────────────────────────
  Future<void> loadServices() async {
    _listStatus = ServiceViewStatus.loading;
    _listErrorMessage = null;
    notifyListeners();

    try {
      final all = await _serviceRepository.getAllServices();
      _allServices = _filterMedicalTestServices(all);
      _services = _applySearch(_allServices);
      _listStatus = _services.isEmpty
          ? ServiceViewStatus.empty
          : ServiceViewStatus.success;
    } on ApiException catch (error) {
      _listErrorMessage = error.message;
      _listStatus = ServiceViewStatus.error;
    } catch (_) {
      _listErrorMessage = 'Không thể tải danh sách dịch vụ xét nghiệm.';
      _listStatus = ServiceViewStatus.error;
    }

    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query.trim();
    _services = _applySearch(_allServices);
    _listStatus = _services.isEmpty
        ? ServiceViewStatus.empty
        : ServiceViewStatus.success;
    notifyListeners();
  }

  // ─── Service detail ───────────────────────────────────────────────────────
  Future<void> loadServiceDetail(int serviceId) async {
    _detailStatus = ServiceViewStatus.loading;
    _detailErrorMessage = null;
    notifyListeners();

    try {
      _serviceDetail = await _serviceRepository.getServiceById(serviceId);
      _detailStatus = ServiceViewStatus.success;
    } on ApiException catch (error) {
      _detailErrorMessage = error.message;
      _detailStatus = ServiceViewStatus.error;
    } catch (_) {
      _detailErrorMessage = 'Không thể tải chi tiết dịch vụ.';
      _detailStatus = ServiceViewStatus.error;
    }

    notifyListeners();
  }

  // ─── Booking ──────────────────────────────────────────────────────────────
  Future<void> initBooking(int serviceId) async {
    _bookingServiceId = serviceId;
    _bookingInitStatus = ServiceViewStatus.loading;
    _bookingInitErrorMessage = null;
    _bookingErrorMessage = null;
    _lastBookedRecordId = null;
    _clearBookingFieldErrors();
    notifyListeners();

    try {
      _bookingService = await _serviceRepository.getServiceById(serviceId);
      _testDate = _dateOnly(DateTime.now());
      await loadWorkShifts();
      _bookingInitStatus = ServiceViewStatus.success;
    } on ApiException catch (error) {
      _bookingInitErrorMessage = error.message;
      _bookingInitStatus = ServiceViewStatus.error;
    } catch (_) {
      _bookingInitErrorMessage = 'Không thể tải thông tin đặt xét nghiệm.';
      _bookingInitStatus = ServiceViewStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadWorkShifts() async {
    _shiftsStatus = ServiceViewStatus.loading;
    _shiftError = null;
    _selectedShiftId = null;
    notifyListeners();

    try {
      _workShifts = await _serviceRepository.getWorkShifts(_dateOnly(_testDate));
      _shiftsStatus = _workShifts.isEmpty
          ? ServiceViewStatus.empty
          : ServiceViewStatus.success;
    } on ApiException catch (error) {
      _shiftsStatus = ServiceViewStatus.error;
      _shiftError = error.message;
    } catch (_) {
      _shiftsStatus = ServiceViewStatus.error;
      _shiftError = 'Không thể tải ca xét nghiệm.';
    }

    notifyListeners();
  }

  void setTestDate(DateTime date) {
    _testDate = _dateOnly(date);
    _testDateError = null;
    loadWorkShifts();
  }

  void setDateOfBirth(DateTime? date) {
    _dateOfBirth = date;
    _dobError = null;
    notifyListeners();
  }

  void setFullName(String value) {
    _fullName = value;
    _fullNameError = null;
    notifyListeners();
  }

  void setGender(String? value) {
    _gender = value;
    _genderError = null;
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value;
    _phoneError = null;
    notifyListeners();
  }

  void selectShift(int? shiftId) {
    _selectedShiftId = shiftId;
    _shiftError = null;
    notifyListeners();
  }

  Future<int?> bookService() async {
    if (!_validateBooking()) {
      return null;
    }

    final serviceId = _bookingServiceId;
    final userId = await SessionHelper.resolveMemberId(_authRepository);
    if (serviceId == null || userId == null) {
      _bookingErrorMessage = 'Vui lòng đăng nhập để đặt xét nghiệm.';
      notifyListeners();
      return null;
    }

    _isBooking = true;
    _bookingErrorMessage = null;
    notifyListeners();

    try {
      final recordId = await _serviceRepository.bookTestService(
        BookTestServiceRequest(
          serviceId: serviceId,
          fullName: _fullName.trim(),
          dob: _dateOfBirth!,
          gender: _gender,
          phoneNumber: AuthValidation.normalizePhone(_phoneNumber),
          testDate: _dateOnly(_testDate),
          userId: userId,
          shift: _selectedShiftId!,
        ),
      );

      if (recordId <= 0) {
        _bookingErrorMessage = 'Đặt xét nghiệm không thành công.';
        return null;
      }

      _lastBookedRecordId = recordId;
      return recordId;
    } on ApiException catch (error) {
      _bookingErrorMessage = error.message;
      return null;
    } catch (_) {
      _bookingErrorMessage = 'Không thể đặt xét nghiệm. Vui lòng thử lại.';
      return null;
    } finally {
      _isBooking = false;
      notifyListeners();
    }
  }

  // ─── Test records ─────────────────────────────────────────────────────────
  Future<void> loadTestRecords() async {
    _recordsStatus = ServiceViewStatus.loading;
    _recordsErrorMessage = null;
    notifyListeners();

    try {
      final memberId = await SessionHelper.resolveMemberId(_authRepository);
      if (memberId == null) {
        _recordsErrorMessage = 'Vui lòng đăng nhập để xem kết quả.';
        _recordsStatus = ServiceViewStatus.error;
        notifyListeners();
        return;
      }

      _allTestRecords = await _serviceRepository.getRecordsByMember(memberId);
      _allTestRecords.sort(
        (a, b) => (b.testDate ?? b.recordDate ?? DateTime(1970))
            .compareTo(a.testDate ?? a.recordDate ?? DateTime(1970)),
      );
      _applyTestRecordFilter();
    } on ApiException catch (error) {
      _recordsErrorMessage = error.message;
      _recordsStatus = ServiceViewStatus.error;
    } catch (_) {
      _recordsErrorMessage = 'Không thể tải lịch sử xét nghiệm.';
      _recordsStatus = ServiceViewStatus.error;
    }

    notifyListeners();
  }

  void setTestRecordFilter(AppointmentHistoryFilter filter) {
    if (_testRecordFilter == filter) {
      return;
    }
    _testRecordFilter = filter;
    _applyTestRecordFilter();
  }

  Future<void> loadTestRecordDetail(int recordId) async {
    _recordDetailStatus = ServiceViewStatus.loading;
    _recordDetailErrorMessage = null;
    notifyListeners();

    try {
      final memberId = await SessionHelper.resolveMemberId(_authRepository);
      if (memberId == null) {
        _recordDetailErrorMessage = 'Vui lòng đăng nhập để xem chi tiết.';
        _recordDetailStatus = ServiceViewStatus.error;
        notifyListeners();
        return;
      }

      _testRecordDetail =
          await _serviceRepository.getRecordDetail(recordId, memberId);
      _recordDetailStatus = ServiceViewStatus.success;
    } on ApiException catch (error) {
      _recordDetailErrorMessage = error.message;
      _recordDetailStatus = ServiceViewStatus.error;
    } catch (_) {
      _recordDetailErrorMessage = 'Không thể tải chi tiết xét nghiệm.';
      _recordDetailStatus = ServiceViewStatus.error;
    }

    notifyListeners();
  }

  Future<bool> cancelTestRecord(int recordId) async {
    final userId = await SessionHelper.resolveMemberId(_authRepository);
    if (userId == null) {
      return false;
    }

    _isCancelling = true;
    notifyListeners();

    try {
      await _serviceRepository.cancelRecord(recordId, userId);
      await loadTestRecordDetail(recordId);
      return true;
    } on ApiException catch (error) {
      _recordDetailErrorMessage = error.message;
      notifyListeners();
      return false;
    } catch (_) {
      _recordDetailErrorMessage = 'Không thể hủy lịch xét nghiệm.';
      notifyListeners();
      return false;
    } finally {
      _isCancelling = false;
      notifyListeners();
    }
  }

  // ─── Private helpers ──────────────────────────────────────────────────────
  void _applyTestRecordFilter() {
    final today = _dateOnly(DateTime.now());
    _testRecords = switch (_testRecordFilter) {
      AppointmentHistoryFilter.all => List.of(_allTestRecords),
      AppointmentHistoryFilter.upcoming => _allTestRecords
          .where(
            (record) => !_recordDay(record).isBefore(today),
          )
          .toList(),
      AppointmentHistoryFilter.past => _allTestRecords
          .where(
            (record) => _recordDay(record).isBefore(today),
          )
          .toList(),
    };

    _recordsStatus = _testRecords.isEmpty
        ? ServiceViewStatus.empty
        : ServiceViewStatus.success;
    notifyListeners();
  }

  static DateTime _recordDay(TestServiceRecord record) =>
      _dateOnly(record.testDate ?? record.recordDate ?? DateTime(1970));

  List<MedicalService> _filterMedicalTestServices(List<MedicalService> all) {
    final tests = all
        .where(
          (service) =>
              !(service.name ?? '').toLowerCase().contains('tư vấn') &&
              !(service.name ?? '').toLowerCase().contains('consult'),
        )
        .toList();
    return tests.isEmpty ? all : tests;
  }

  List<MedicalService> _applySearch(List<MedicalService> source) {
    if (_searchQuery.isEmpty) {
      return List.of(source);
    }
    final query = _searchQuery.toLowerCase();
    return source
        .where(
          (service) =>
              (service.name ?? '').toLowerCase().contains(query) ||
              (service.description ?? '').toLowerCase().contains(query),
        )
        .toList();
  }

  bool _validateBooking() {
    _fullNameError = ServiceValidation.fullName(_fullName);
    _genderError = ServiceValidation.gender(_gender);
    _phoneError = ServiceValidation.phoneNumber(_phoneNumber);
    _dobError = ServiceValidation.dateOfBirth(_dateOfBirth);
    _testDateError = ServiceValidation.testDate(_testDate);
    _shiftError = ServiceValidation.shift(_selectedShiftId);

    final isValid = _fullNameError == null &&
        _genderError == null &&
        _phoneError == null &&
        _dobError == null &&
        _testDateError == null &&
        _shiftError == null;
    notifyListeners();
    return isValid;
  }

  void _clearBookingFieldErrors() {
    _fullNameError = null;
    _genderError = null;
    _phoneError = null;
    _dobError = null;
    _testDateError = null;
    _shiftError = null;
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);
}
