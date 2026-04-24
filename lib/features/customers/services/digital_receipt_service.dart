import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wameedpos/features/customers/models/digital_receipt_log.dart';
import 'package:wameedpos/features/customers/repositories/customer_repository.dart';

/// Sends a digital receipt for a completed order.
///
/// - **email**: Server-side delivery (recorded by `DigitalReceiptService` on
///   the Laravel side, returns a [DigitalReceiptLog] row).
/// - **whatsapp / sms**: Server records the log row, then we open a deep link
///   (`wa.me/<digits>?text=...` or `sms:<digits>?body=...`) so the merchant
///   can finish sending from their device — no third-party API key required
///   for the MVP.
class DigitalReceiptService {
  DigitalReceiptService(this._repo);
  final CustomerRepository _repo;

  Future<DigitalReceiptLog> sendEmail({required String customerId, required String orderId, String? destination}) =>
      _repo.sendReceipt(customerId, orderId: orderId, channel: 'email', destination: destination);

  Future<DigitalReceiptLog> sendWhatsApp({
    required String customerId,
    required String orderId,
    required String phone,
    required String receiptUrl,
  }) async {
    final log = await _repo.sendReceipt(customerId, orderId: orderId, channel: 'whatsapp', destination: phone);
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    final uri = Uri.parse('https://wa.me/$digits?text=${Uri.encodeComponent(receiptUrl)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return log;
  }

  Future<DigitalReceiptLog> sendSms({
    required String customerId,
    required String orderId,
    required String phone,
    required String body,
  }) async {
    final log = await _repo.sendReceipt(customerId, orderId: orderId, channel: 'sms', destination: phone);
    final uri = Uri.parse('sms:$phone?body=${Uri.encodeComponent(body)}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
    return log;
  }
}

final digitalReceiptServiceProvider = Provider<DigitalReceiptService>((ref) {
  return DigitalReceiptService(ref.watch(customerRepositoryProvider));
});
