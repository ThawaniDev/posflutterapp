import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/features/zatca/models/zatca_certificate.dart';
import 'package:wameedpos/features/zatca/models/zatca_connection_status.dart';
import 'package:wameedpos/features/zatca/models/zatca_device.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice_detail.dart';
import 'package:wameedpos/features/zatca/repositories/zatca_repository.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

// ─── Enrollment Provider ───────────────────────────────────────

final zatcaEnrollmentProvider = StateNotifierProvider<ZatcaEnrollmentNotifier, ZatcaEnrollmentState>((ref) {
  return ZatcaEnrollmentNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaEnrollmentNotifier extends StateNotifier<ZatcaEnrollmentState> {
  ZatcaEnrollmentNotifier(this._repo) : super(const ZatcaEnrollmentInitial());
  final ZatcaRepository _repo;

  Future<void> enroll({required String otp, required String environment}) async {
    state = const ZatcaEnrollmentLoading();
    try {
      final result = await _repo.enroll(otp: otp, environment: environment);
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaEnrollmentSuccess(data);
    } catch (e) {
      state = ZatcaEnrollmentError(e.toString());
    }
  }

  Future<void> renew() async {
    state = const ZatcaEnrollmentLoading();
    try {
      final result = await _repo.renewCertificate();
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaEnrollmentSuccess(data);
    } catch (e) {
      state = ZatcaEnrollmentError(e.toString());
    }
  }
}

// ─── Invoice List Provider ─────────────────────────────────────

final zatcaInvoiceListProvider = StateNotifierProvider<ZatcaInvoiceListNotifier, ZatcaInvoiceListState>((ref) {
  return ZatcaInvoiceListNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaInvoiceListNotifier extends StateNotifier<ZatcaInvoiceListState> {
  ZatcaInvoiceListNotifier(this._repo) : super(const ZatcaInvoiceListInitial());
  final ZatcaRepository _repo;

  Future<void> load({String? status, String? invoiceType, String? dateFrom, String? dateTo, int? perPage}) async {
    state = const ZatcaInvoiceListLoading();
    try {
      final result = await _repo.listInvoices(
        status: status,
        invoiceType: invoiceType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        perPage: perPage,
      );
      final data = result['data'] as Map<String, dynamic>;
      final items = (data['data'] as List).map((e) => ZatcaInvoice.fromJson(e as Map<String, dynamic>)).toList();
      final meta = data['meta'] as Map<String, dynamic>;
      state = ZatcaInvoiceListLoaded(
        invoices: items,
        currentPage: meta['current_page'] as int,
        lastPage: meta['last_page'] as int,
        total: meta['total'] as int,
      );
    } catch (e) {
      state = ZatcaInvoiceListError(e.toString());
    }
  }
}

// ─── Compliance Summary Provider ───────────────────────────────

final zatcaComplianceSummaryProvider = StateNotifierProvider<ZatcaComplianceSummaryNotifier, ZatcaComplianceSummaryState>((ref) {
  return ZatcaComplianceSummaryNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaComplianceSummaryNotifier extends StateNotifier<ZatcaComplianceSummaryState> {
  ZatcaComplianceSummaryNotifier(this._repo) : super(const ZatcaComplianceSummaryInitial());
  final ZatcaRepository _repo;

  Future<void> load() async {
    state = const ZatcaComplianceSummaryLoading();
    try {
      final result = await _repo.complianceSummary();
      final data = result['data'] as Map<String, dynamic>;
      final certData = data['certificate'] as Map<String, dynamic>?;
      state = ZatcaComplianceSummaryLoaded(
        totalInvoices: data['total_invoices'] as int,
        accepted: data['accepted'] as int,
        rejected: data['rejected'] as int,
        pending: data['pending'] as int,
        successRate: double.tryParse(data['success_rate'].toString()) ?? 0.0,
        certificate: certData != null ? ZatcaCertificate.fromJson(certData) : null,
      );
    } catch (e) {
      state = ZatcaComplianceSummaryError(e.toString());
    }
  }
}

// ─── VAT Report Provider ───────────────────────────────────────

final zatcaVatReportProvider = StateNotifierProvider<ZatcaVatReportNotifier, ZatcaVatReportState>((ref) {
  return ZatcaVatReportNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaVatReportNotifier extends StateNotifier<ZatcaVatReportState> {
  ZatcaVatReportNotifier(this._repo) : super(const ZatcaVatReportInitial());
  final ZatcaRepository _repo;

  Future<void> load({String? dateFrom, String? dateTo}) async {
    state = const ZatcaVatReportLoading();
    try {
      final result = await _repo.vatReport(dateFrom: dateFrom, dateTo: dateTo);
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaVatReportLoaded(
        standardInvoices: Map<String, dynamic>.from(data['standard_invoices'] as Map),
        simplifiedInvoices: Map<String, dynamic>.from(data['simplified_invoices'] as Map),
        totalVatCollected: double.tryParse(data['total_vat_collected'].toString()) ?? 0.0,
        totalAmount: double.tryParse(data['total_amount'].toString()) ?? 0.0,
      );
    } catch (e) {
      state = ZatcaVatReportError(e.toString());
    }
  }
}

// ─── Device Provider ───────────────────────────────────────

final zatcaDeviceProvider = StateNotifierProvider<ZatcaDeviceNotifier, ZatcaDeviceState>((ref) {
  return ZatcaDeviceNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaDeviceNotifier extends StateNotifier<ZatcaDeviceState> {
  ZatcaDeviceNotifier(this._repo) : super(const ZatcaDeviceInitial());
  final ZatcaRepository _repo;

  Future<void> load() async {
    state = const ZatcaDeviceLoading();
    try {
      final result = await _repo.listDevices();
      final data = result['data'] as Map<String, dynamic>;
      final list = (data['devices'] as List).map((e) => ZatcaDevice.fromJson(Map<String, dynamic>.from(e as Map))).toList();
      state = ZatcaDeviceListLoaded(list);
    } catch (e) {
      state = ZatcaDeviceError(e.toString());
    }
  }

  Future<void> provision({String environment = 'sandbox'}) async {
    state = const ZatcaDeviceLoading();
    try {
      final result = await _repo.provisionDevice(environment: environment);
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaDeviceProvisioned(
        deviceId: data['device_id'] as String,
        deviceUuid: data['device_uuid'] as String,
        activationCode: data['activation_code'] as String,
      );
    } catch (e) {
      state = ZatcaDeviceError(e.toString());
    }
  }

  Future<void> activate({required String activationCode, String? hardwareSerial}) async {
    state = const ZatcaDeviceLoading();
    try {
      final result = await _repo.activateDevice(activationCode: activationCode, hardwareSerial: hardwareSerial);
      final data = result['data'] as Map<String, dynamic>;
      state = ZatcaDeviceActivated(ZatcaDevice.fromJson(data));
    } catch (e) {
      state = ZatcaDeviceError(e.toString());
    }
  }

  Future<void> resetTamper(String deviceId) async {
    state = const ZatcaDeviceLoading();
    try {
      await _repo.resetDeviceTamper(deviceId);
      await load();
    } catch (e) {
      state = ZatcaDeviceError(e.toString());
    }
  }
}

// ─── Connection Status Provider ────────────────────────────

final zatcaConnectionProvider = StateNotifierProvider<ZatcaConnectionNotifier, ZatcaConnectionState>((ref) {
  return ZatcaConnectionNotifier(ref.watch(zatcaRepositoryProvider));
});

class ZatcaConnectionNotifier extends StateNotifier<ZatcaConnectionState> {
  ZatcaConnectionNotifier(this._repo) : super(const ZatcaConnectionInitial());
  final ZatcaRepository _repo;

  Future<void> load() async {
    state = const ZatcaConnectionLoading();
    try {
      final result = await _repo.connectionStatus();
      final data = Map<String, dynamic>.from(result['data'] as Map);
      state = ZatcaConnectionLoaded(ZatcaConnectionStatus.fromJson(data));
    } catch (e) {
      state = ZatcaConnectionError(e.toString());
    }
  }
}

// ─── Invoice Detail Provider ───────────────────────────────

final zatcaInvoiceDetailProvider = StateNotifierProvider.family<ZatcaInvoiceDetailNotifier, ZatcaInvoiceDetailState, String>((
  ref,
  id,
) {
  return ZatcaInvoiceDetailNotifier(ref.watch(zatcaRepositoryProvider), id);
});

class ZatcaInvoiceDetailNotifier extends StateNotifier<ZatcaInvoiceDetailState> {
  ZatcaInvoiceDetailNotifier(this._repo, this._invoiceId) : super(const ZatcaInvoiceDetailInitial());
  final ZatcaRepository _repo;
  final String _invoiceId;

  Future<void> load() async {
    state = const ZatcaInvoiceDetailLoading();
    try {
      final result = await _repo.getInvoiceDetail(_invoiceId);
      final data = Map<String, dynamic>.from(result['data'] as Map);
      state = ZatcaInvoiceDetailLoaded(ZatcaInvoiceDetail.fromJson(data));
    } catch (e) {
      state = ZatcaInvoiceDetailError(e.toString());
    }
  }

  Future<void> retry() async {
    final current = state;
    if (current is! ZatcaInvoiceDetailLoaded) {
      return;
    }
    state = ZatcaInvoiceDetailLoaded(current.detail, retrying: true);
    try {
      final result = await _repo.retrySubmission(_invoiceId);
      final message = result['message'] as String?;
      // Re-fetch to refresh statuses + cleared XML.
      final detailResult = await _repo.getInvoiceDetail(_invoiceId);
      final data = Map<String, dynamic>.from(detailResult['data'] as Map);
      state = ZatcaInvoiceDetailLoaded(ZatcaInvoiceDetail.fromJson(data), retryMessage: message);
    } catch (e) {
      state = ZatcaInvoiceDetailError(e.toString());
    }
  }
}
