import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../../../../shared/extensions/context_extensions.dart';
import '../bloc/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController();
  final _phoneTextController = TextEditingController();
  String _phoneNumber = '';
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_onFieldsChanged);
  }

  void _onFieldsChanged() => setState(() {});

  bool get _canSubmit =>
      _phoneNumber.isNotEmpty && _passwordController.text.isNotEmpty;

  @override
  void dispose() {
    _passwordController.removeListener(_onFieldsChanged);
    _passwordController.dispose();
    _phoneTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            context.showSnackBar(state.message, backgroundColor: Colors.red);
          }
          if (state is AuthSuccess) {
            context.showSnackBar('Connexion réussie, bienvenue !',
                backgroundColor: Colors.green);
            context.go('/home');
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/images/login_hero.jpg',
                      // Proportionnel a la hauteur d'ecran (plutot qu'une
                      // valeur fixe en pixels) pour s'adapter automatiquement
                      // aux differentes tailles/resolutions d'appareil, sans
                      // pousser "Rejoignez-nous"/le copyright hors de l'ecran
                      // sur les appareils plus petits.
                      height: MediaQuery.of(context).size.height * 0.20,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Bonjour',
                          style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(width: 8),
                      const Text('👋', style: TextStyle(fontSize: 28)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Prêt pour effectuer votre commande ?',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 48),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Numéro de Téléphone',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  const SizedBox(height: 4),
                  IntlPhoneField(
                    controller: _phoneTextController,
                    decoration: InputDecoration(
                      suffixIcon: _phoneTextController.text.isEmpty
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                _phoneTextController.clear();
                                setState(() => _phoneNumber = '');
                              },
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                    initialCountryCode: 'CM', // Cameroun par défaut
                    keyboardType: TextInputType.phone,
                    // Sans indicatif pays : c'est le format utilise a
                    // l'inscription/reinitialisation (TextFormField brut sur
                    // ces pages) et donc le username Keycloak reel. Envoyer
                    // completeNumber (+237...) ici ne correspondrait a aucun
                    // compte existant.
                    onChanged: (phone) =>
                        setState(() => _phoneNumber = phone.number),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Mot de passe',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: isLoading
                            ? null
                            : () => context.push('/reset-password'),
                        child: const Text('Mot de passe oublié ?'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: (isLoading || !_canSubmit)
                          ? null
                          : () => context.read<AuthBloc>().add(
                                LoginRequested(
                                  username: _phoneNumber,
                                  password: _passwordController.text,
                                ),
                              ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Se connecter'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text("Vous n'etes pas encore membre ?"),
                      TextButton(
                        onPressed:
                            isLoading ? null : () => context.push('/register'),
                        child: const Text('Rejoignez-nous'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Copyright  phannuella couture ${DateTime.now().year}',
                    style: Theme.of(context).textTheme.bodySmall,
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
