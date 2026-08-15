import 'package:dio/dio.dart';

import '../../../../core/errors/api_error_extractor.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

/// Route reelle : ApiTailorManagement/.../Controllers/v1/PaymentsController.cs
/// (api/v1/orders/{orderId}/payments, api/v1/payments/{paymentId}/status).
class PaymentRepositoryImpl implements PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepositoryImpl(this._apiClient);

  @override
  Future<Payment> initiatePayment({
    required String orderId,
    required String paymentMethod,
    required String accountNumber,
    required String paymentType,
  }) async {
    try {
      final response = await _apiClient.post(
        '/orders/$orderId/payments',
        data: {
          'paymentMethod': paymentMethod,
          'accountNumber': accountNumber,
          'paymentType': paymentType,
        },
      );
      return Payment.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        extractApiErrorMessage(e, fallback: 'Paiement impossible, veuillez reessayer'),
      );
    }
  }

  @override
  Future<Payment> getPaymentStatus(String paymentId) async {
    try {
      final response = await _apiClient.get('/payments/$paymentId/status');
      return Payment.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw ServerException(
        extractApiErrorMessage(e, fallback: 'Impossible de verifier le statut du paiement'),
      );
    }
  }
}
