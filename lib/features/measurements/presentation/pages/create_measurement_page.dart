import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/keycloak_service.dart';
import '../../../../shared/extensions/context_extensions.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../customers/domain/entities/customer.dart';
import '../../../customers/domain/repositories/customer_repository.dart';
import '../bloc/measurement_bloc.dart';

/// Formulaire de creation de mesure. Le Customer associe est celui de
/// l'utilisateur connecte (Keycloak, username = numero de telephone) --
/// recupere automatiquement, on ne lui redemande pas de se choisir
/// lui-meme dans une liste a chaque fois.
class CreateMeasurementPage extends StatelessWidget {
  const CreateMeasurementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const _CreateMeasurementForm();
  }
}

class _CreateMeasurementForm extends StatefulWidget {
  const _CreateMeasurementForm();

  @override
  State<_CreateMeasurementForm> createState() => _CreateMeasurementFormState();
}

class _CreateMeasurementFormState extends State<_CreateMeasurementForm> {
  final _formKey = GlobalKey<FormState>();
  late final Future<Customer?> _connectedCustomer = _loadConnectedCustomer();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _shoulderController = TextEditingController();
  final _sleeveController = TextEditingController();
  final _trouserController = TextEditingController();
  final _neckController = TextEditingController();

  Future<Customer?> _loadConnectedCustomer() async {
    final claims = await sl<KeycloakService>().getUserClaims();
    final phoneNumber = claims?['preferred_username'] as String?;
    if (phoneNumber == null) return null;
    return sl<CustomerRepository>().getCustomerByPhoneNumber(phoneNumber);
  }

  @override
  void dispose() {
    _chestController.dispose();
    _waistController.dispose();
    _shoulderController.dispose();
    _sleeveController.dispose();
    _trouserController.dispose();
    _neckController.dispose();
    super.dispose();
  }

  double? _parse(String text) => text.trim().isEmpty ? null : double.tryParse(text.trim());

  void _submit(Customer customer) {
    if (!_formKey.currentState!.validate()) return;
    context.read<MeasurementBloc>().add(CreateMeasurement({
          'customerId': customer.id,
          'chest': _parse(_chestController.text),
          'waist': _parse(_waistController.text),
          'shoulderWidth': _parse(_shoulderController.text),
          'sleeveLength': _parse(_sleeveController.text),
          'trouserLength': _parse(_trouserController.text),
          'neckSize': _parse(_neckController.text),
        }));
  }

  Widget _numberField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        decoration: InputDecoration(labelText: '$label (cm)'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nouvelle mesure')),
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

          return BlocListener<MeasurementBloc, MeasurementState>(
            listener: (context, state) {
              if (state is MeasurementOperationSuccess) {
                Navigator.of(context).pop();
              }
              if (state is MeasurementError) {
                context.showSnackBar(state.message, backgroundColor: Colors.red);
              }
            },
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.person_outline),
                    title: Text('${customer.firstName} ${customer.lastName}'),
                    subtitle: const Text('Client'),
                  ),
                  const SizedBox(height: 16),
                  _numberField(_chestController, 'Poitrine'),
                  _numberField(_waistController, 'Taille'),
                  _numberField(_shoulderController, 'Epaules'),
                  _numberField(_sleeveController, 'Manche'),
                  _numberField(_trouserController, 'Pantalon'),
                  _numberField(_neckController, 'Cou'),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => _submit(customer),
                    child: const Text('Enregistrer'),
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
