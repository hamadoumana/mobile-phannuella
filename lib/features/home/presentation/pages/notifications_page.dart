import 'package:flutter/material.dart';

import '../../../../shared/widgets/empty_state_widget.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      // TODO(FIREBASE): alimenter cette liste via firebase_messaging une fois
      // le projet Firebase configure (cf. TODO(FIREBASE) dans lib/main.dart).
      body: const EmptyStateWidget(message: 'Aucune notification pour le moment'),
    );
  }
}
