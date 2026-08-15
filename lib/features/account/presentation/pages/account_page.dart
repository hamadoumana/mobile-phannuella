import 'package:flutter/material.dart';

import '../../../../core/di/injection_container.dart';
import '../../../../core/network/keycloak_service.dart';
import '../../../../shared/widgets/loading_widget.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mon compte')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: sl<KeycloakService>().getUserClaims(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingWidget();
          }

          final claims = snapshot.data;
          if (claims == null) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'Mode invite : aucun compte Keycloak associe.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final username = claims['preferred_username'] as String? ?? 'Non renseigne';
          final email = claims['email'] as String? ?? 'Non renseigne';
          final fullName = claims['name'] as String? ??
              [claims['given_name'], claims['family_name']]
                  .whereType<String>()
                  .join(' ')
                  .trim();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              const SizedBox(height: 24),
              _InfoTile(label: 'Nom complet', value: fullName.isEmpty ? 'Non renseigne' : fullName),
              _InfoTile(label: "Nom d'utilisateur", value: username),
              _InfoTile(label: 'Email', value: email),
            ],
          );
        },
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;

  const _InfoTile({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: Theme.of(context).textTheme.labelMedium),
      subtitle: Text(value, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
