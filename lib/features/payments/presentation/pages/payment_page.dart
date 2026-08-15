import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/keycloak_service.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/picker_field.dart';
import '../../../orders/domain/entities/order.dart' as orders;
import '../../domain/entities/payment.dart';
import '../bloc/payment_bloc.dart';

/// Page de paiement Mobile Money (MTN/Orange) via KratosPay pour une commande
/// deja creee. Accessible juste apres la creation de la commande (flux
/// "commander et payer" depuis la fiche produit).
class PaymentPage extends StatelessWidget {
  final orders.Order order;

  const PaymentPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PaymentBloc>(),
      child: _PaymentForm(order: order),
    );
  }
}

class _PaymentForm extends StatefulWidget {
  final orders.Order order;

  const _PaymentForm({required this.order});

  @override
  State<_PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<_PaymentForm> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  String _paymentType = PaymentType.complet;
  String? _paymentMethod;

  @override
  void initState() {
    super.initState();
    _prefillAccountNumber();
  }

  Future<void> _prefillAccountNumber() async {
    final claims = await sl<KeycloakService>().getUserClaims();
    final phoneNumber = claims?['preferred_username'] as String?;
    if (phoneNumber != null && mounted) {
      setState(() => _accountController.text = phoneNumber);
    }
  }

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  double get _totalAmount => widget.order.totalPrice + (widget.order.shippingFee ?? 0);

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_paymentMethod == null) {
      context.showSnackBar('Choisir un mode de paiement', backgroundColor: Colors.red);
      return;
    }
    context.read<PaymentBloc>().add(
          InitiatePaymentRequested(
            orderId: widget.order.id,
            paymentMethod: _paymentMethod!,
            accountNumber: _accountController.text.trim(),
            paymentType: _paymentType,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paiement')),
      body: BlocConsumer<PaymentBloc, PaymentState>(
        listener: (context, state) {
          if (state is PaymentError) {
            context.showSnackBar(state.message, backgroundColor: Colors.red);
          }
        },
        builder: (context, state) {
          if (state is PaymentPending) return _PendingView(payment: state.payment);
          if (state is PaymentSuccess) return _ResultView(payment: state.payment, success: true);
          if (state is PaymentFailed) return _ResultView(payment: state.payment, success: false);

          final isLoading = state is PaymentInitiating;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Recapitulatif', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Total a payer'),
                              Text(
                                Formatters.currency(_totalAmount),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Type de paiement', style: Theme.of(context).textTheme.titleSmall),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Paiement complet'),
                    value: PaymentType.complet,
                    groupValue: _paymentType,
                    onChanged: (value) => setState(() => _paymentType = value!),
                  ),
                  RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Acompte (solde a la livraison)'),
                    value: PaymentType.acompte,
                    groupValue: _paymentType,
                    onChanged: (value) => setState(() => _paymentType = value!),
                  ),
                  const SizedBox(height: 12),
                  PickerFormField<String>(
                    label: 'Mode de paiement',
                    items: PaymentMethod.values,
                    itemLabel: PaymentMethod.label,
                    initialValue: _paymentMethod,
                    onChanged: (value) => setState(() => _paymentMethod = value),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _accountController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(labelText: 'Numero Mobile Money'),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Numero Mobile Money requis' : null,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Payer'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PendingView extends StatelessWidget {
  final Payment payment;

  const _PendingView({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            Text(
              'Confirmez le paiement ${PaymentMethod.label(payment.paymentMethod)} sur votre telephone (${payment.accountNumber})',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              Formatters.currency(payment.amount),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (payment.balanceDue != null) ...[
              const SizedBox(height: 4),
              Text('Solde a la livraison : ${Formatters.currency(payment.balanceDue!)}'),
            ],
            const SizedBox(height: 16),
            Text(
              'Reference : ${payment.kratosPayReference}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Votre commande sera confirmee des reception du paiement.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  final Payment payment;
  final bool success;

  const _ResultView({required this.payment, required this.success});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              success ? Icons.check_circle : Icons.error,
              color: success ? Colors.green : Colors.red,
              size: 72,
            ),
            const SizedBox(height: 16),
            Text(
              success ? 'Paiement confirme !' : 'Paiement echoue ou annule',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (success) ...[
              const SizedBox(height: 8),
              Text(Formatters.currency(payment.amount)),
              if (payment.balanceDue != null)
                Text('Solde a la livraison : ${Formatters.currency(payment.balanceDue!)}'),
            ],
            const SizedBox(height: 24),
            FilledButton(
              // PaymentPage est empilee de facon imperative (Navigator.push
              // depuis la fiche produit / la commande), par-dessus la pile
              // geree par go_router -- context.go('/home') ne "voit" pas ces
              // routes imperatives et ne fait donc rien. On depile jusqu'a
              // la premiere route (Accueil) au lieu de changer d'URL.
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Text('Retour a l\'accueil'),
            ),
          ],
        ),
      ),
    );
  }
}
