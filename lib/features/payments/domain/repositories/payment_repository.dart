import '../entities/payment.dart';

abstract class PaymentRepository {
  Future<Payment> initiatePayment({
    required String orderId,
    required String paymentMethod,
    required String accountNumber,
    required String paymentType,
  });

  Future<Payment> getPaymentStatus(String paymentId);
}
