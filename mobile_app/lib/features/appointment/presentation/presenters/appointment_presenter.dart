import 'package:flutter/foundation.dart';

import '../../../../core/network/api_exception.dart';
import '../../../../core/utils/session_helper.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../consultant/domain/entities/consultant.dart';
import '../../../consultant/domain/repositories/consultant_repository.dart';
import '../../../service/domain/entities/medical_service.dart';
import '../../../service/domain/repositories/service_repository.dart';
import '../../domain/entities/appointment.dart';
import '../../domain/entities/create_appointment_request.dart';
import '../../domain/repositories/appointment_repository.dart';
import 'appointment_view_status.dart';

/// MVP presenter for appointment history, detail, and booking.
class AppointmentPresenter extends ChangeNotifier {
  AppointmentPresenter({
    required AppointmentRepository appointmentRepository,
    required ConsultantRepository consultantRepository,
    required ServiceRepository serviceRepository,
    required AuthRepository authRepository,
  })  : _appointmentRepository = appointmentRepository,
        _consultantRepository = consultantRepository,
        _serviceRepository = serviceRepository,
        _authRepository = authRepository;

  final AppointmentRepository _appointmentRepository;
  final ConsultantRepository _consultantRepository;
  final ServiceRepository _serviceRepository;
  final AuthRepository _authRepository;

  // ─── List / history ───────────────────────────────────────────────────────
  AppointmentViewStatus _listStatus = AppointmentViewStatus.idle;
  List<Appointment> _allAppointments = [];
  List<Appointment> _appointments = [];
  AppointmentHistoryFilter _historyFilter = AppointmentHistoryFilter.all;
  AppointmentListTab _listTab = AppointmentListTab.consultations;
  String? _listErrorMessage;

  // ─── Detail ───────────────────────────────────────────────────────────────
  AppointmentViewStatus _detailStatus = AppointmentViewStatus.idle;
  AppointmentDetail? _appointmentDetail;
  String? _detailErrorMessage;

  // ─── Booking / slot selection ─────────────────────────────────────────────
  AppointmentViewStatus _bookingInitStatus = AppointmentViewStatus.idle;
  AppointmentViewStatus _slotsStatus = AppointmentViewStatus.idle;
  int? _bookingConsultantId;
  ConsultantDetail? _bookingConsultant;
  String? _bookingInitErrorMessage;

  DateTime _selectedDate = DateTime.now();
  List<String> _availableSlots = [];
  String? _selectedSlot;
  String? _slotsErrorMessage;

  List<MedicalService> _consultationServices = [];
  int? _selectedServiceId;
  String _symptoms = '';
  bool _isCreating = false;
  String? _createErrorMessage;
  int? _lastCreatedAppointmentId;

  // ─── Getters ──────────────────────────────────────────────────────────────
  AppointmentViewStatus get listStatus => _listStatus;
  List<Appointment> get appointments => _appointments;
  AppointmentHistoryFilter get historyFilter => _historyFilter;
  AppointmentListTab get listTab => _listTab;
  String? get listErrorMessage => _listErrorMessage;

  AppointmentViewStatus get detailStatus => _detailStatus;
  AppointmentDetail? get appointmentDetail => _appointmentDetail;
  String? get detailErrorMessage => _detailErrorMessage;

  AppointmentViewStatus get bookingInitStatus => _bookingInitStatus;
  AppointmentViewStatus get slotsStatus => _slotsStatus;
  ConsultantDetail? get bookingConsultant => _bookingConsultant;
  String? get bookingInitErrorMessage => _bookingInitErrorMessage;
  DateTime get selectedDate => _selectedDate;
  List<String> get availableSlots => _availableSlots;
  String? get selectedSlot => _selectedSlot;
  String? get slotsErrorMessage => _slotsErrorMessage;
  List<MedicalService> get consultationServices => _consultationServices;
  int? get selectedServiceId => _selectedServiceId;
  String get symptoms => _symptoms;
  bool get isCreating => _isCreating;
  String? get createErrorMessage => _createErrorMessage;
  int? get lastCreatedAppointmentId => _lastCreatedAppointmentId;

  // ─── History ──────────────────────────────────────────────────────────────
  Future<void> loadAppointmentHistory() async {
    _listStatus = AppointmentViewStatus.loading;
    _listErrorMessage = null;
    notifyListeners();

    try {
      final memberId = await SessionHelper.resolveMemberId(_authRepository);
      if (memberId == null) {
        _listErrorMessage = 'Vui lòng đăng nhập để xem lịch hẹn.';
        _listStatus = AppointmentViewStatus.error;
        notifyListeners();
        return;
      }

      _allAppointments =
          await _appointmentRepository.getAppointmentsByMember(memberId);
      _allAppointments.sort((a, b) => b.startTime.compareTo(a.startTime));
      _applyHistoryFilter();
    } on ApiException catch (error) {
      _listErrorMessage = error.message;
      _listStatus = AppointmentViewStatus.error;
    } catch (_) {
      _listErrorMessage = 'Không thể tải lịch sử lịch hẹn.';
      _listStatus = AppointmentViewStatus.error;
    }

    notifyListeners();
  }

  Future<void> refreshHistory() => loadAppointmentHistory();

  void setListTab(AppointmentListTab tab) {
    if (_listTab == tab) {
      return;
    }
    _listTab = tab;
    notifyListeners();
  }

  void setHistoryFilter(AppointmentHistoryFilter filter) {
    if (_historyFilter == filter) {
      return;
    }
    _historyFilter = filter;
    _applyHistoryFilter();
  }

  // ─── Detail ───────────────────────────────────────────────────────────────
  Future<void> loadAppointmentDetail(int appointmentId) async {
    _detailStatus = AppointmentViewStatus.loading;
    _detailErrorMessage = null;
    notifyListeners();

    try {
      _appointmentDetail =
          await _appointmentRepository.getAppointmentDetail(appointmentId);
      _detailStatus = AppointmentViewStatus.success;
    } on ApiException catch (error) {
      _detailErrorMessage = error.message;
      _detailStatus = AppointmentViewStatus.error;
    } catch (_) {
      _detailErrorMessage = 'Không thể tải chi tiết lịch hẹn.';
      _detailStatus = AppointmentViewStatus.error;
    }

    notifyListeners();
  }

  // ─── Booking initialization ───────────────────────────────────────────────
  Future<void> initSlotSelection(int consultantId) async {
    _bookingConsultantId = consultantId;
    _bookingInitStatus = AppointmentViewStatus.loading;
    _bookingInitErrorMessage = null;
    _createErrorMessage = null;
    _lastCreatedAppointmentId = null;
    _selectedDate = _dateOnly(DateTime.now());
    _selectedSlot = null;
    notifyListeners();

    try {
      _bookingConsultant =
          await _consultantRepository.getConsultantDetail(consultantId);
      await Future.wait([
        _loadConsultationServices(),
        loadAvailableSlots(),
      ]);
      _bookingInitStatus = AppointmentViewStatus.success;
    } on ApiException catch (error) {
      _bookingInitErrorMessage = error.message;
      _bookingInitStatus = AppointmentViewStatus.error;
    } catch (_) {
      _bookingInitErrorMessage = 'Không thể tải thông tin đặt lịch.';
      _bookingInitStatus = AppointmentViewStatus.error;
    }

    notifyListeners();
  }

  Future<void> loadAvailableSlots() async {
    final consultantId = _bookingConsultantId;
    if (consultantId == null) {
      return;
    }

    _slotsStatus = AppointmentViewStatus.loading;
    _slotsErrorMessage = null;
    _selectedSlot = null;
    notifyListeners();

    try {
      _availableSlots = await _consultantRepository.getAvailableSlots(
        consultantId,
        _dateOnly(_selectedDate),
      );
      _slotsStatus = _availableSlots.isEmpty
          ? AppointmentViewStatus.empty
          : AppointmentViewStatus.success;
    } on ApiException catch (error) {
      _slotsErrorMessage = error.message;
      _slotsStatus = AppointmentViewStatus.error;
    } catch (_) {
      _slotsErrorMessage = 'Không thể tải khung giờ trống.';
      _slotsStatus = AppointmentViewStatus.error;
    }

    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    _selectedDate = _dateOnly(date);
    loadAvailableSlots();
  }

  void selectSlot(String? slot) {
    _selectedSlot = slot;
    _createErrorMessage = null;
    notifyListeners();
  }

  void setSelectedServiceId(int? serviceId) {
    _selectedServiceId = serviceId;
    _createErrorMessage = null;
    notifyListeners();
  }

  void setSymptoms(String value) {
    _symptoms = value;
    notifyListeners();
  }

  /// Creates an appointment for the selected slot. Returns id on success.
  Future<int?> createAppointment() async {
    final consultantId = _bookingConsultantId;
    final slot = _selectedSlot;
    final serviceId = _selectedServiceId;

    if (consultantId == null) {
      _createErrorMessage = 'Không xác định được tư vấn viên.';
      notifyListeners();
      return null;
    }
    if (slot == null) {
      _createErrorMessage = 'Vui lòng chọn khung giờ.';
      notifyListeners();
      return null;
    }
    if (serviceId == null) {
      _createErrorMessage = 'Vui lòng chọn dịch vụ tư vấn.';
      notifyListeners();
      return null;
    }

    final memberId = await SessionHelper.resolveMemberId(_authRepository);
    if (memberId == null) {
      _createErrorMessage = 'Vui lòng đăng nhập để đặt lịch.';
      notifyListeners();
      return null;
    }

    _isCreating = true;
    _createErrorMessage = null;
    notifyListeners();

    try {
      final startTime = _parseSlotDateTime(_selectedDate, slot);
      final endTime = startTime.add(const Duration(minutes: 30));

      final appointmentId = await _appointmentRepository.createAppointment(
        CreateAppointmentRequest(
          memberId: memberId,
          serviceId: serviceId,
          consultantId: consultantId,
          startTime: startTime,
          endTime: endTime,
          symptoms: _symptoms.trim().isEmpty ? null : _symptoms.trim(),
        ),
      );

      if (appointmentId <= 0) {
        _createErrorMessage = 'Đặt lịch không thành công. Vui lòng thử lại.';
        return null;
      }

      _lastCreatedAppointmentId = appointmentId;
      return appointmentId;
    } on ApiException catch (error) {
      _createErrorMessage = error.message;
      return null;
    } catch (_) {
      _createErrorMessage = 'Không thể đặt lịch. Vui lòng thử lại.';
      return null;
    } finally {
      _isCreating = false;
      notifyListeners();
    }
  }

  // ─── Private helpers ──────────────────────────────────────────────────────
  void _applyHistoryFilter() {
    final now = DateTime.now();
    _appointments = switch (_historyFilter) {
      AppointmentHistoryFilter.all => List.of(_allAppointments),
      AppointmentHistoryFilter.upcoming => _allAppointments
          .where((a) => a.startTime.isAfter(now))
          .toList(),
      AppointmentHistoryFilter.past => _allAppointments
          .where((a) => !a.startTime.isAfter(now))
          .toList(),
    };

    _listStatus = _appointments.isEmpty
        ? AppointmentViewStatus.empty
        : AppointmentViewStatus.success;
    notifyListeners();
  }

  Future<void> _loadConsultationServices() async {
    try {
      final services = await _serviceRepository.getAllServices();
      _consultationServices = services
          .where(
            (service) =>
                (service.name ?? '').toLowerCase().contains('tư vấn') ||
                (service.name ?? '').toLowerCase().contains('consult'),
          )
          .toList();

      if (_consultationServices.isEmpty && services.isNotEmpty) {
        _consultationServices = services;
      }

      _selectedServiceId ??=
          _consultationServices.isNotEmpty
              ? _consultationServices.first.serviceId
              : null;
    } catch (_) {
      _consultationServices = [];
    }
  }

  static DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime _parseSlotDateTime(DateTime date, String slot) {
    final parts = slot.split(':');
    final hour = int.tryParse(parts.first) ?? 0;
    final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return DateTime(date.year, date.month, date.day, hour, minute);
  }
}
