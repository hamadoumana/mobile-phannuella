import 'package:equatable/equatable.dart';

/// Modes de paiement Mobile Money reels du backend
/// (ApiTailorManagement/.../Domain/Payments/PaymentMethod.cs).
class PaymentMethod {
  PaymentMethod._();

  static const mtnMoney = 'MTN_MONEY';
  static const orangeMoney = 'ORANGE_MONEY';

  static const values = [mtnMoney, orangeMoney];

  static String label(String value) {
    switch (value) {
      case mtnMoney:
        return 'MTN MoMo';
      case orangeMoney:
        return 'Orange Money';
      default:
        return value;
    }
  }
}

/// Types de paiement reels du backend
/// (ApiTailorManagement/.../Domain/Payments/PaymentType.cs).
class PaymentType {
  PaymentType._();

  static const complet = 'complet';
  static const acompte = 'acompte';
}

/// Statuts reels du backend
/// (ApiTailorManagement/.../Domain/Payments/PaymentStatus.cs).
class PaymentStatus {
  PaymentStatus._();

  static const enAttente = 'en_attente';
  static const reussi = 'reussi';
  static const echoue = 'echoue';

  static bool isFinal(String status) => status == reussi || status == echoue;
}

/// Miroir de l'entite backend `Payment`
/// (ApiTailorManagement/.../Domain/Payments/Payment.cs).
class Payment extends Equatable {
  final String id;
  final String orderId;
  final String paymentMethod;
  final String accountNumber;
  final String paymentType;
  final double amount;
  final double? balanceDue;
  final String kratosPayReference;
  final String? kratosPayTransactionId;
  final String status;
  final DateTime? confirmedAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.paymentMethod,
    required this.accountNumber,
    required this.paymentType,
    required this.amount,
    this.balanceDue,
    required this.kratosPayReference,
    this.kratosPayTransactionId,
    required this.status,
    this.confirmedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        id: json['id'] as String,
        orderId: json['orderId'] as String,
        paymentMethod: json['paymentMethod'] as String,
        accountNumber: json['accountNumber'] as String,
        paymentType: json['paymentType'] as String,
        amount: (json['amount'] as num).toDouble(),
        balanceDue: (json['balanceDue'] as num?)?.toDouble(),
        kratosPayReference: json['kratosPayReference'] as String,
        kratosPayTransactionId: json['kratosPayTransactionId'] as String?,
        status: json['status'] as String,
        confirmedAt:
            json['confirmedAt'] != null ? DateTime.parse(json['confirmedAt'] as String) : null,
      );

  @override
  List<Object?> get props => [
        id,
        orderId,
        paymentMethod,
        accountNumber,
        paymentType,
        amount,
        balanceDue,
        kratosPayReference,
        kratosPayTransactionId,
        status,
        confirmedAt,
      ];
}
