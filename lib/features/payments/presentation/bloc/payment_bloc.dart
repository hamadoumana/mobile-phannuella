import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/errors/error_handler.dart';
import '../../domain/entities/payment.dart';
import '../../domain/repositories/payment_repository.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository _repository;
  Timer? _pollTimer;

  PaymentBloc(this._repository) : super(const PaymentInitial()) {
    on<InitiatePaymentRequested>(_onInitiatePaymentRequested);
    on<PollPaymentStatus>(_onPollPaymentStatus);
  }

  Future<void> _onInitiatePaymentRequested(
    InitiatePaymentRequested event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentInitiating());
    try {
      final payment = await _repository.initiatePayment(
        orderId: event.orderId,
        paymentMethod: event.paymentMethod,
        accountNumber: event.accountNumber,
        paymentType: event.paymentType,
      );
      _handlePaymentUpdate(payment, emit);
    } catch (e) {
      emit(PaymentError(ErrorHandler.handle(e).message));
    }
  }

  Future<void> _onPollPaymentStatus(
    PollPaymentStatus event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      final payment = await _repository.getPaymentStatus(event.paymentId);
      _handlePaymentUpdate(payment, emit);
    } catch (_) {
      // Hoquet reseau pendant le polling : on ignore et on reessaie au
      // prochain tick plutot que d'interrompre le suivi du paiement.
    }
  }

  void _handlePaymentUpdate(Payment payment, Emitter<PaymentState> emit) {
    if (PaymentStatus.isFinal(payment.status)) {
      _pollTimer?.cancel();
      emit(payment.status == PaymentStatus.reussi ? PaymentSuccess(payment) : PaymentFailed(payment));
      return;
    }
    emit(PaymentPending(payment));
    _startPolling(payment.id);
  }

  void _startPolling(String paymentId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => add(PollPaymentStatus(paymentId)),
    );
  }

  @override
  Future<void> close() {
    _pollTimer?.cancel();
    return super.close();
  }
}
