part of 'payment_bloc.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePaymentRequested extends PaymentEvent {
  final String orderId;
  final String paymentMethod;
  final String accountNumber;
  final String paymentType;

  const InitiatePaymentRequested({
    required this.orderId,
    required this.paymentMethod,
    required this.accountNumber,
    required this.paymentType,
  });

  @override
  List<Object?> get props => [orderId, paymentMethod, accountNumber, paymentType];
}

class PollPaymentStatus extends PaymentEvent {
  final String paymentId;

  const PollPaymentStatus(this.paymentId);

  @override
  List<Object?> get props => [paymentId];
}
