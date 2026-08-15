part of 'payment_bloc.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

class PaymentInitiating extends PaymentState {
  const PaymentInitiating();
}

/// Paiement cree cote KratosPay, en attente de confirmation du client sur son
/// telephone (le PaymentBloc poll automatiquement le statut en arriere-plan).
class PaymentPending extends PaymentState {
  final Payment payment;
  const PaymentPending(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentSuccess extends PaymentState {
  final Payment payment;
  const PaymentSuccess(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentFailed extends PaymentState {
  final Payment payment;
  const PaymentFailed(this.payment);

  @override
  List<Object?> get props => [payment];
}

class PaymentError extends PaymentState {
  final String message;
  const PaymentError(this.message);

  @override
  List<Object?> get props => [message];
}
