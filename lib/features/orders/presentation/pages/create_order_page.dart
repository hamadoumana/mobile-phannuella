import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/keycloak_service.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/picker_field.dart';
import '../../../clothing_models/domain/entities/clothing_model.dart';
import '../../../clothing_models/presentation/bloc/clothing_model_bloc.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/domain/repositories/customer_repository.dart';
import '../../../fabrics/domain/entities/fabric.dart';
import '../../../fabrics/presentation/bloc/fabric_bloc.dart';
import '../../../tailors/domain/entities/tailor.dart';
import '../../../tailors/presentation/bloc/tailor_bloc.dart';
import '../../../payments/presentation/pages/payment_page.dart';
import '../../domain/entities/order.dart';
import '../bloc/order_bloc.dart';

/// Formulaire de creation de commande, en 2 etapes (Client & Produit, puis
/// Details de la commande) pour rester lisible sur mobile.
///
/// Le Customer associe a la commande est celui de l'utilisateur connecte
/// (Keycloak, username = numero de telephone) -- recupere automatiquement,
/// on ne lui redemande pas de se choisir lui-meme dans une liste.
///
/// Les autres selections (modele/tissu/couturier/taille/mode de retrait)
/// utilisent [PickerFormField] (feuille de bas d'ecran) plutot qu'un
/// `DropdownButtonFormField` -- ce dernier s'est avere peu fiable sur
/// l'emulateur des qu'une liste depasse quelques elements (menu qui ne se
/// ferme jamais apres selection, sans exception levee).
class CreateOrderPage extends StatelessWidget {
  final ClothingModel? initialClothingModel;

  const CreateOrderPage({super.key, this.initialClothingModel});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ClothingModelBloc>()..add(const LoadClothingModels())),
        BlocProvider(create: (_) => sl<FabricBloc>()..add(const LoadFabrics())),
        BlocProvider(create: (_) => sl<TailorBloc>()..add(const LoadTailors())),
      ],
      child: _CreateOrderForm(initialClothingModel: initialClothingModel),
    );
  }
}

class _CreateOrderForm extends StatefulWidget {
  final ClothingModel? initialClothingModel;

  const _CreateOrderForm({this.initialClothingModel});

  @override
  State<_CreateOrderForm> createState() => _CreateOrderFormState();
}

class _CreateOrderFormState extends State<_CreateOrderForm> {
  final _formKey = GlobalKey<FormState>();
  late final Future<Customer?> _connectedCustomer = _loadConnectedCustomer();
  int _currentStep = 0;

  late ClothingModel? _clothingModel = widget.initialClothingModel;
  Fabric? _fabric;
  Tailor? _tailor;
  String? _size;
  String? _pickupMode;
  DateTime? _deliveryDate;
  final _quantityController = TextEditingController(text: '1');
  final _colorController = TextEditingController();
  final _delayDaysController = TextEditingController();

  Future<Customer?> _loadConnectedCustomer() async {
    final claims = await sl<KeycloakService>().getUserClaims();
    final phoneNumber = claims?['preferred_username'] as String?;
    if (phoneNumber == null) return null;
    return sl<CustomerRepository>().getCustomerByPhoneNumber(phoneNumber);
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _colorController.dispose();
    _delayDaysController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  Future<void> _pickDeliveryDate() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (date != null) {
      // UTC explicite : le backend (Postgres/Npgsql) rejette les DateTime
      // Kind=Unspecified (ce que produirait toIso8601String() sur une date
      // "locale" issue de showDatePicker sans conversion).
      setState(() => _deliveryDate = DateTime.utc(date.year, date.month, date.day));
    }
  }

  void _submit(Customer customer) {
    if (!_formKey.currentState!.validate()) return;
    if (_deliveryDate == null) {
      context.showSnackBar('Choisir une date de livraison', backgroundColor: Colors.red);
      return;
    }

    context.read<OrderBloc>().add(CreateOrder({
          'customerId': customer.id,
          'clothingModelId': _clothingModel!.id,
          'fabricId': _fabric!.id,
          'quantity': int.parse(_quantityController.text),
          'deliveryDate': _deliveryDate!.toIso8601String(),
          'tailorId': _tailor?.id,
          'size': _size,
          'color': _colorController.text.trim().isEmpty ? null : _colorController.text.trim(),
          'delayDays': int.tryParse(_delayDaysController.text.trim()),
          'pickupMode': _pickupMode,
        }));
  }

  void _onStepContinue() {
    if (_clothingModel == null || _fabric == null) {
      context.showSnackBar(
        'Choisir un modele et un tissu avant de continuer',
        backgroundColor: Colors.red,
      );
      return;
    }
    setState(() => _currentStep = 1);
  }

  void _onStepCancel() {
    if (_currentStep == 0) {
      Navigator.of(context).pop();
      return;
    }
    setState(() => _currentStep = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle commande')),
      body: FutureBuilder<Customer?>(
        future: _connectedCustomer,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingWidget();
          }

          final customer = snapshot.data;
          if (customer == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "Impossible de retrouver votre profil client. Veuillez vous reconnecter.",
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return BlocListener<OrderBloc, OrderState>(
            listener: (context, state) {
              if (state is OrderOperationSuccess) {
                final createdOrder = state.order;
                if (createdOrder != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => PaymentPage(order: createdOrder)),
                  );
                } else {
                  Navigator.of(context).pop();
                }
              }
              if (state is OrderError) {
                context.showSnackBar(state.message, backgroundColor: Colors.red);
              }
            },
            child: Form(
              key: _formKey,
              child: Stepper(
                currentStep: _currentStep,
                onStepContinue: _currentStep == 0 ? _onStepContinue : () => _submit(customer),
                onStepCancel: _onStepCancel,
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed: details.onStepContinue,
                          child: Text(_currentStep == 0 ? 'Suivant' : 'Commander'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: details.onStepCancel,
                          child: Text(_currentStep == 0 ? 'Annuler' : 'Retour'),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text('Client & Produit'),
                    isActive: _currentStep >= 0,
                    state: _currentStep > 0 ? StepState.complete : StepState.indexed,
                    content: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.person_outline),
                          title: Text('${customer.firstName} ${customer.lastName}'),
                          subtitle: const Text('Client'),
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<ClothingModelBloc, ClothingModelState>(
                          builder: (context, state) {
                            final models = state is ClothingModelLoaded
                                ? state.clothingModels
                                : const <ClothingModel>[];
                            return PickerFormField<ClothingModel>(
                              label: 'Modele',
                              items: models,
                              itemLabel: (m) => m.modelName,
                              initialValue: _clothingModel,
                              onChanged: (value) => setState(() => _clothingModel = value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<FabricBloc, FabricState>(
                          builder: (context, state) {
                            final fabrics =
                                state is FabricLoaded ? state.fabrics : const <Fabric>[];
                            return PickerFormField<Fabric>(
                              label: 'Tissu',
                              items: fabrics,
                              itemLabel: (f) => f.fabricName,
                              initialValue: _fabric,
                              onChanged: (value) => setState(() => _fabric = value),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<TailorBloc, TailorState>(
                          builder: (context, state) {
                            final tailors =
                                state is TailorLoaded ? state.tailors : const <Tailor>[];
                            return PickerFormField<Tailor>(
                              label: 'Couturier (optionnel)',
                              items: tailors,
                              itemLabel: (t) => '${t.name} (${t.city})',
                              initialValue: _tailor,
                              onChanged: (value) => setState(() => _tailor = value),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Details de la commande'),
                    isActive: _currentStep >= 1,
                    state: StepState.indexed,
                    content: Column(
                      children: [
                        TextFormField(
                          controller: _quantityController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Quantite'),
                          validator: (value) =>
                              int.tryParse(value ?? '') == null ? 'Quantite invalide' : null,
                        ),
                        const SizedBox(height: 12),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            _deliveryDate == null
                                ? 'Date de livraison'
                                : _formatDate(_deliveryDate!),
                          ),
                          trailing: const Icon(Icons.calendar_today_outlined),
                          onTap: _pickDeliveryDate,
                        ),
                        const SizedBox(height: 12),
                        PickerFormField<String>(
                          label: 'Taille (optionnel)',
                          items: OrderSize.values,
                          itemLabel: (s) => s,
                          initialValue: _size,
                          onChanged: (value) => setState(() => _size = value),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _colorController,
                          decoration: const InputDecoration(labelText: 'Couleur (optionnel)'),
                        ),
                        const SizedBox(height: 12),
                        PickerFormField<String>(
                          label: 'Mode de retrait (optionnel)',
                          items: PickupMode.values,
                          itemLabel: PickupMode.label,
                          initialValue: _pickupMode,
                          onChanged: (value) => setState(() => _pickupMode = value),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _delayDaysController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Delai (jours, optionnel)'),
                        ),
                      ],
                    ),
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
