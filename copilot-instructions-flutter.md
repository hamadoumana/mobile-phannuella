# GitHub Copilot \- Instructions Personnalisées (Flutter \+ Firebase)

## Stratégie Git et Gestion des Branches

### Structure des Branches

Ce projet utilise **Git Flow simplifié** avec les branches suivantes :

- **`main`** : Branche de production, toujours stable et déployable  
- **`develop`** : Branche d'intégration pour le développement en cours  
- **`feature/*`** : Branches pour les nouvelles fonctionnalités (ex: `feature/auth`, `feature/commandes`)  
- **`hotfix/*`** : Branches pour les corrections urgentes en production  
- **`release/*`** : Branches de préparation de release (optionnel)

### Workflow de Développement

1. **Créer une feature branch depuis develop**  
     
   git checkout develop  
     
   git pull origin develop  
     
   git checkout \-b feature/nom-de-la-feature  
     
2. **Développer et commiter régulièrement**  
     
   git add .  
     
   git commit \-m "feat: description de la fonctionnalité"  
     
3. **Pousser la feature branch**  
     
   git push \-u origin feature/nom-de-la-feature  
     
4. **Créer une Pull Request vers develop**  
     
   - La PR doit être reviewée par au moins 1 autre développeur  
   - Tous les tests CI doivent passer  
   - Pas de conflits avec develop

   

5. **Merger dans develop après validation**  
     
   git checkout develop  
     
   git merge \--no-ff feature/nom-de-la-feature  
     
   git push origin develop  
     
6. **Supprimer la feature branch**  
     
   git branch \-d feature/nom-de-la-feature  
     
   git push origin \--delete feature/nom-de-la-feature

### Conventions de Commit

Utiliser **Conventional Commits** :

- `feat:` Nouvelle fonctionnalité  
- `fix:` Correction de bug  
- `docs:` Documentation seulement  
- `style:` Formatage, organisation du code  
- `refactor:` Refactoring de code  
- `test:` Ajout ou modification de tests  
- `chore:` Maintenance, configuration  
- `perf:` Amélioration de performance

**Exemples :**

feat(auth): intégrer Keycloak pour l'authentification

fix(commandes): corriger la validation des dates

docs(readme): mettre à jour les instructions d'installation

refactor(tissus): optimiser le chargement des listes

test(factures): ajouter tests unitaires du bloc

### Code Review

**Checklist avant de créer une PR :**

- [ ] Le code suit les conventions du projet  
- [ ] Les tests unitaires sont écrits et passent (`flutter test`)  
- [ ] La documentation est à jour  
- [ ] Pas de `print()` ou code de debug  
- [ ] Les secrets ne sont pas commités (pas de clé Firebase, Keycloak en dur)  
- [ ] Le code compile sans warnings (`flutter analyze`)  
- [ ] Les fichiers `firebase_options.dart` et `.env` sont dans `.gitignore`

**Checklist pour le reviewer :**

- [ ] La fonctionnalité répond au besoin  
- [ ] Le code est lisible et maintenable  
- [ ] Les patterns du projet sont respectés (BLoC, Repository)  
- [ ] Pas de code dupliqué  
- [ ] Les tests sont pertinents  
- [ ] La performance est acceptable (pas de rebuild inutile)  
- [ ] Pas d'appel HTTP direct depuis un widget

---

## Architecture et Patterns

Ce projet suit une **Clean Architecture** avec **BLoC Pattern** et les principes suivants :

### Structure du Projet

lib/

├── core/                          \# Code transversal

│   ├── constants/

│   │   ├── app\_constants.dart

│   │   ├── api\_constants.dart

│   │   └── firebase\_constants.dart

│   ├── errors/

│   │   ├── exceptions.dart         \# AppException + sous-classes (Network, Unauthorized, ...)

│   │   ├── error\_handler.dart      \# ErrorHandler.handle(e) -\> AppException (OBLIGATOIRE dans les BLoC)

│   │   └── api\_error\_extractor.dart \# Lit le ProblemDetails du backend (detail/errors/title)

│   ├── network/

│   │   └── api\_client.dart        \# Client Dio avec intercepteur Keycloak

│   ├── theme/

│   │   └── app\_theme.dart

│   └── utils/

│       ├── validators.dart

│       └── formatters.dart

│

├── features/                      \# Un dossier par domaine métier

│   ├── auth/

│   │   ├── data/

│   │   │   ├── models/

│   │   │   └── repositories/

│   │   ├── domain/

│   │   │   ├── entities/

│   │   │   └── repositories/     \# Interfaces

│   │   └── presentation/

│   │       ├── bloc/

│   │       │   ├── auth\_bloc.dart

│   │       │   ├── auth\_event.dart

│   │       │   └── auth\_state.dart

│   │       ├── pages/

│   │       │   ├── login\_page.dart

│   │       │   └── register\_page.dart

│   │       └── widgets/

│   │

│   ├── commandes/

│   │   ├── data/

│   │   ├── domain/

│   │   └── presentation/

│   │

│   ├── tissus/

│   │   ├── data/

│   │   ├── domain/

│   │   └── presentation/

│   │

│   ├── modeles/

│   │   ├── data/

│   │   ├── domain/

│   │   └── presentation/

│   │

│   └── payments/                  \# Paiement Mobile Money (KratosPay), voir section dediee

│       ├── data/

│       ├── domain/

│       └── presentation/

│           └── bloc/              \# PaymentBloc : initie + poll le statut jusqu'a etat final

│

├── shared/                        \# Widgets et helpers partagés

│   ├── widgets/

│   │   ├── loading\_widget.dart

│   │   ├── error\_widget.dart

│   │   └── empty\_state\_widget.dart

│   └── extensions/

│       ├── string\_extensions.dart

│       └── context\_extensions.dart

│

├── firebase\_options.dart          \# Généré par FlutterFire CLI

└── main.dart

### Technologies Principales

- **Flutter 3.x** (Dart 3.x) — framework mobile multiplateforme  
- **Firebase** — plateforme de services cloud  
  - `firebase_core` — initialisation obligatoire  
  - `firebase_messaging` — notifications push (FCM)  
  - `firebase_crashlytics` — rapport de crashes  
  - `firebase_analytics` — statistiques d'utilisation  
  - `firebase_remote_config` — configuration à distance  
- **Keycloak** — authentification et gestion des utilisateurs (via `http` \+ `flutter_secure_storage`)  
- **Dio** — client HTTP avec intercepteurs pour JWT Keycloak  
- **flutter\_bloc** — gestion d'état (BLoC Pattern)  
- **equatable** — comparaison d'états dans BLoC  
- **flutter\_secure\_storage** — stockage sécurisé des tokens  
- **jwt\_decoder** — décodage local du JWT Keycloak  
- **intl\_phone\_field** — champ téléphone avec sélecteur d'indicatif pays (page de connexion)  
- **go\_router** — navigation déclarative  
- **get\_it** — injection de dépendances  
- **flutter\_local\_notifications** — affichage local des notifications FCM  
- **mocktail** — mocking pour les tests unitaires

>   
> **Note importante** : Firebase Auth **n'est pas utilisé** dans ce projet. L'authentification est gérée exclusivement par **Keycloak** via l'API backend ASP.NET Core. Firebase est utilisé uniquement pour : FCM, Crashlytics, Analytics, Remote Config.

>   
> **Paiement** : les paiements Mobile Money (MTN MoMo / Orange Money) passent par **KratosPay**, mais toujours via le backend (`/api/v1/orders/{id}/payments`, `/api/v1/payments/{id}/status`) — l'app mobile n'appelle jamais KratosPay directement et ne détient aucun secret marchand.

---

## Conventions de Code

### 1\. Structure d'une Entité (Domain)

// lib/features/commandes/domain/entities/commande.dart

class Commande extends Equatable {

  final String id;

  final String clientId;

  final String statut;

  final double montantTotal;

  final DateTime dateCreation;

  final DateTime? dateLivraison;

  const Commande({

    required this.id,

    required this.clientId,

    required this.statut,

    required this.montantTotal,

    required this.dateCreation,

    this.dateLivraison,

  });

  // Factory depuis JSON (data layer)

  factory Commande.fromJson(Map\<String, dynamic\> json) \=\> Commande(

        id: json\['id'\],

        clientId: json\['clientId'\],

        statut: json\['statut'\],

        montantTotal: (json\['montantTotal'\] as num).toDouble(),

        dateCreation: DateTime.parse(json\['dateCreation'\]),

        dateLivraison: json\['dateLivraison'\] \!= null

            ? DateTime.parse(json\['dateLivraison'\])

            : null,

      );

  Map\<String, dynamic\> toJson() \=\> {

        'id': id,

        'clientId': clientId,

        'statut': statut,

        'montantTotal': montantTotal,

        'dateCreation': dateCreation.toIso8601String(),

        'dateLivraison': dateLivraison?.toIso8601String(),

      };

  @override

  List\<Object?\> get props \=\> \[

        id, clientId, statut, montantTotal, dateCreation, dateLivraison

      \];

}

### 2\. Structure des Events BLoC

// lib/features/commandes/presentation/bloc/commande\_event.dart

part of 'commande\_bloc.dart';

abstract class CommandeEvent extends Equatable {

  const CommandeEvent();

  @override

  List\<Object?\> get props \=\> \[\];

}

class LoadCommandes extends CommandeEvent {

  final String? statut;

  const LoadCommandes({this.statut});

  @override

  List\<Object?\> get props \=\> \[statut\];

}

class CreateCommande extends CommandeEvent {

  final Map\<String, dynamic\> data;

  const CreateCommande(this.data);

  @override

  List\<Object?\> get props \=\> \[data\];

}

class DeleteCommande extends CommandeEvent {

  final String id;

  const DeleteCommande(this.id);

  @override

  List\<Object?\> get props \=\> \[id\];

}

class RefreshCommandes extends CommandeEvent {

  const RefreshCommandes();

}

### 3\. Structure des States BLoC

// lib/features/commandes/presentation/bloc/commande\_state.dart

part of 'commande\_bloc.dart';

abstract class CommandeState extends Equatable {

  const CommandeState();

  @override

  List\<Object?\> get props \=\> \[\];

}

class CommandeInitial extends CommandeState {

  const CommandeInitial();

}

class CommandeLoading extends CommandeState {

  const CommandeLoading();

}

class CommandeLoaded extends CommandeState {

  final List\<Commande\> commandes;

  const CommandeLoaded(this.commandes);

  @override

  List\<Object?\> get props \=\> \[commandes\];

}

class CommandeOperationSuccess extends CommandeState {

  final String message;

  const CommandeOperationSuccess(this.message);

  @override

  List\<Object?\> get props \=\> \[message\];

}

class CommandeError extends CommandeState {

  final String message;

  const CommandeError(this.message);

  @override

  List\<Object?\> get props \=\> \[message\];

}

### 4\. Structure du BLoC

// lib/features/commandes/presentation/bloc/commande\_bloc.dart

import 'package:flutter\_bloc/flutter\_bloc.dart';

import 'package:equatable/equatable.dart';

import '../../../../core/errors/error\_handler.dart';

import '../../data/repositories/commande\_repository.dart';

import '../../domain/entities/commande.dart';

part 'commande\_event.dart';

part 'commande\_state.dart';

class CommandeBloc extends Bloc\<CommandeEvent, CommandeState\> {

  final CommandeRepository \_repository;

  CommandeBloc(this.\_repository) : super(const CommandeInitial()) {

    on\<LoadCommandes\>(\_onLoadCommandes);

    on\<CreateCommande\>(\_onCreateCommande);

    on\<DeleteCommande\>(\_onDeleteCommande);

    on\<RefreshCommandes\>(\_onRefreshCommandes);

  }

  Future\<void\> \_onLoadCommandes(

    LoadCommandes event,

    Emitter\<CommandeState\> emit,

  ) async {

    emit(const CommandeLoading());

    try {

      final commandes \= await \_repository.getCommandes(statut: event.statut);

      emit(CommandeLoaded(commandes));

    } catch (e) {

      emit(CommandeError(ErrorHandler.handle(e).message));

    }

  }

  Future\<void\> \_onCreateCommande(

    CreateCommande event,

    Emitter\<CommandeState\> emit,

  ) async {

    try {

      await \_repository.createCommande(event.data);

      emit(const CommandeOperationSuccess('Commande créée avec succès'));

      add(const RefreshCommandes());

    } catch (e) {

      emit(CommandeError(ErrorHandler.handle(e).message));

    }

  }

  Future\<void\> \_onDeleteCommande(

    DeleteCommande event,

    Emitter\<CommandeState\> emit,

  ) async {

    try {

      await \_repository.deleteCommande(event.id);

      if (state is CommandeLoaded) {

        final current \= (state as CommandeLoaded).commandes;

        emit(CommandeLoaded(

          current.where((c) \=\> c.id \!= event.id).toList(),

        ));

      }

    } catch (e) {

      emit(CommandeError(ErrorHandler.handle(e).message));

    }

  }

  Future\<void\> \_onRefreshCommandes(

    RefreshCommandes event,

    Emitter\<CommandeState\> emit,

  ) async {

    add(const LoadCommandes());

  }

}

### 5\. Structure d'un Repository

// lib/features/commandes/data/repositories/commande\_repository.dart

import '../../../../core/network/api\_client.dart';

import '../../domain/entities/commande.dart';

class CommandeRepository {

  final ApiClient \_apiClient;

  CommandeRepository(this.\_apiClient);

  Future\<List\<Commande\>\> getCommandes({String? statut}) async {

    final response \= await \_apiClient.get(

      '/api/commandes',

      queryParams: statut \!= null ? {'statut': statut} : null,

    );

    return (response.data as List)

        .map((json) \=\> Commande.fromJson(json))

        .toList();

  }

  Future\<Commande\> getCommande(String id) async {

    final response \= await \_apiClient.get('/api/commandes/$id');

    return Commande.fromJson(response.data);

  }

  Future\<Commande\> createCommande(Map\<String, dynamic\> data) async {

    final response \= await \_apiClient.post('/api/commandes', data: data);

    return Commande.fromJson(response.data);

  }

  Future\<void\> deleteCommande(String id) async {

    await \_apiClient.delete('/api/commandes/$id');

  }

}

### 6\. Structure d'un Widget / Page

// lib/features/commandes/presentation/pages/commande\_list\_page.dart

import 'package:flutter/material.dart';

import 'package:flutter\_bloc/flutter\_bloc.dart';

import '../bloc/commande\_bloc.dart';

import '../widgets/commande\_card.dart';

class CommandeListPage extends StatelessWidget {

  const CommandeListPage({super.key});

  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(title: const Text('Commandes')),

      body: BlocConsumer\<CommandeBloc, CommandeState\>(

        // listener : effets de bord uniquement (snackbar, navigation)

        listener: (context, state) {

          if (state is CommandeError) {

            ScaffoldMessenger.of(context).showSnackBar(

              SnackBar(

                content: Text(state.message),

                backgroundColor: Colors.red,

              ),

            );

          }

          if (state is CommandeOperationSuccess) {

            ScaffoldMessenger.of(context).showSnackBar(

              SnackBar(

                content: Text(state.message),

                backgroundColor: Colors.green,

              ),

            );

          }

        },

        // builder : reconstruction de l'UI uniquement

        builder: (context, state) {

          if (state is CommandeLoading) {

            return const Center(child: CircularProgressIndicator());

          }

          if (state is CommandeLoaded) {

            if (state.commandes.isEmpty) {

              return const Center(child: Text('Aucune commande trouvée'));

            }

            return RefreshIndicator(

              onRefresh: () async \=\>

                  context.read\<CommandeBloc\>().add(const RefreshCommandes()),

              child: ListView.builder(

                itemCount: state.commandes.length,

                itemBuilder: (context, index) \=\>

                    CommandeCard(commande: state.commandes\[index\]),

              ),

            );

          }

          return const SizedBox.shrink();

        },

      ),

    );

  }

}

### 7\. Structure des Tests Unitaires

// test/features/commandes/bloc/commande\_bloc\_test.dart

import 'package:flutter\_test/flutter\_test.dart';

import 'package:bloc\_test/bloc\_test.dart';

import 'package:mocktail/mocktail.dart';

import 'package:mon\_app/features/commandes/data/repositories/commande\_repository.dart';

import 'package:mon\_app/features/commandes/presentation/bloc/commande\_bloc.dart';

import 'package:mon\_app/features/commandes/domain/entities/commande.dart';

class MockCommandeRepository extends Mock implements CommandeRepository {}

void main() {

  late CommandeBloc bloc;

  late MockCommandeRepository mockRepository;

  setUp(() {

    mockRepository \= MockCommandeRepository();

    bloc \= CommandeBloc(mockRepository);

  });

  tearDown(() \=\> bloc.close());

  group('LoadCommandes', () {

    final fakeCommandes \= \[

      Commande(

        id: '1',

        clientId: 'client-1',

        statut: 'EN\_ATTENTE',

        montantTotal: 15000,

        dateCreation: DateTime(2026, 1, 1),

      ),

    \];

    blocTest\<CommandeBloc, CommandeState\>(

      'émet \[CommandeLoading, CommandeLoaded\] quand la liste est chargée avec succès',

      build: () {

        when(() \=\> mockRepository.getCommandes(statut: any(named: 'statut')))

            .thenAnswer((\_) async \=\> fakeCommandes);

        return bloc;

      },

      act: (bloc) \=\> bloc.add(const LoadCommandes()),

      expect: () \=\> \[

        const CommandeLoading(),

        CommandeLoaded(fakeCommandes),

      \],

    );

    blocTest\<CommandeBloc, CommandeState\>(

      'émet \[CommandeLoading, CommandeError\] quand le chargement échoue',

      build: () {

        when(() \=\> mockRepository.getCommandes(statut: any(named: 'statut')))

            .thenThrow(Exception('Erreur réseau'));

        return bloc;

      },

      act: (bloc) \=\> bloc.add(const LoadCommandes()),

      expect: () \=\> \[

        const CommandeLoading(),

        isA\<CommandeError\>(),

      \],

    );

  });

}

### 8\. Gestion des erreurs (AppException \+ ErrorHandler) — OBLIGATOIRE

Toute exception personnalisée doit hériter de `AppException`. Un seul point de conversion
(`ErrorHandler.handle(e)`) transforme n'importe quelle erreur (réseau, HTTP, timeout Dio **et**
`dart:async`, ou déjà une `AppException`) en message lisible. **Ne jamais** faire
`emit(XError(e.toString()))` — ça peut afficher un message brut illisible à l'utilisateur
(ex: `TimeoutException after 0:00:08.000000: ...`).

// lib/core/errors/exceptions.dart

class AppException implements Exception {

  final String message;

  const AppException(this.message);

  @override

  String toString() \=\> message;

}

class ServerException extends AppException {

  const ServerException(\[super.message \= 'Erreur serveur, veuillez reessayer plus tard'\]);

}

class NetworkException extends AppException {

  const NetworkException(\[super.message \= 'Pas de connexion internet'\]);

}

// RequestTimeoutException (pas "TimeoutException" \-\- collision avec dart:async)

class RequestTimeoutException extends AppException {

  const RequestTimeoutException(\[super.message \= 'Connexion trop lente, veuillez reessayer'\]);

}

class UnauthorizedException extends AppException {

  const UnauthorizedException(\[super.message \= 'Numero ou mot de passe incorrect'\]);

}

// lib/core/errors/error\_handler.dart (utilisation dans un BLoC)

try {

  await \_repository.doSomething();

} catch (e) {

  emit(XError(ErrorHandler.handle(e).message));

}

`ErrorHandler.handle()` mappe automatiquement les codes HTTP courants (401 \=\> Unauthorized, 404 \=\>
NotFound, 409 \=\> AccountAlreadyExists, 5xx \=\> Server) en lisant le vrai format ProblemDetails du
backend (`detail`/`errors`, pas un champ `message`) via `extractApiErrorMessage()`.

---

## Règles à Respecter

### Général

1. **Dart 3.x** — utiliser les nouvelles syntaxes (records, patterns, sealed classes)  
2. **const constructors** partout où possible pour optimiser les rebuilds  
3. **Aucun appel HTTP direct depuis un Widget** — toujours passer par un BLoC → Repository  
4. **Séparation stricte** : UI (presentation) / logique métier (bloc) / données (data) / domaine (domain)  
5. **Nullable safety** activé sur tout le projet  
6. **Pas de setState()** dans les pages principales — utiliser BLoC  
7. **Pas de Firebase Auth** — l'auth est gérée par Keycloak  
8. **Toujours await les Future** — pas de fire-and-forget silencieux  
9. **Secrets jamais en dur** dans le code — utiliser `.env` avec `flutter_dotenv`  
10. **Toute exception hérite de `AppException`** ; tout `catch` dans un BLoC MUST utiliser `ErrorHandler.handle(e).message` — jamais `e.toString()` directement

### Naming Conventions

| Élément | Convention | Exemple |
| :---- | :---- | :---- |
| Classes | PascalCase | `CommandeBloc`, `TissuRepository` |
| Fichiers | snake\_case | `commande_bloc.dart` |
| Variables/méthodes | camelCase | `montantTotal`, `loadCommandes()` |
| Constantes | camelCase ou SCREAMING\_SNAKE | `apiBaseUrl`, `API_TIMEOUT` |
| Tests | description snake\_case | `émet_loading_puis_loaded_quand_succès` |
| Events | Verbe \+ Nom | `LoadCommandes`, `CreateCommande` |
| States | Nom \+ État | `CommandeLoading`, `CommandeLoaded` |

### Sécurité et Authentification

1. **Keycloak** est le seul système d'authentification — ne pas utiliser Firebase Auth  
2. **Stocker les tokens avec `flutter_secure_storage`** — jamais dans SharedPreferences  
3. **Renouveler le JWT automatiquement** via l'intercepteur Dio avant expiration  
4. **Invalider le token côté Keycloak** lors de la déconnexion (appel au endpoint `/logout`)  
5. **Ne jamais logger les tokens** JWT ou informations sensibles  
6. **Chiffrer les données sensibles** avant stockage local si nécessaire  
7. **Le numéro de téléphone (sans indicatif pays) est le username Keycloak** — c'est le format utilisé à l'inscription (`TextFormField` brut) et donc celui à envoyer à la connexion, pas `phone.completeNumber` avec le `+237`  
8. **Inscription et réinitialisation de mot de passe passent toujours par le backend** (`POST /api/v1/auth/register`, `POST /api/v1/auth/reset-password`) — l'app mobile n'appelle **jamais** l'API Admin Keycloak directement et n'embarque aucun identifiant admin/service-account

### Firebase (Périmètre autorisé)

| Service | Utilisation autorisée |
| :---- | :---- |
| `firebase_messaging` (FCM) | ✅ Notifications push |
| `firebase_crashlytics` | ✅ Rapport de crashes |
| `firebase_analytics` | ✅ Statistiques d'utilisation |
| `firebase_remote_config` | ✅ Configuration dynamique |
| `firebase_auth` | ❌ Interdit — utiliser Keycloak |
| `cloud_firestore` | ❌ Interdit — utiliser l'API backend |
| `firebase_storage` | ❌ Interdit sauf décision explicite |

### Notifications Push (FCM)

1. **Toujours demander la permission** avant d'enregistrer le token FCM  
2. **Sauvegarder le token FCM dans le backend** (via API ASP.NET Core) pour les notifications ciblées  
3. **Gérer les 3 états** : foreground, background, app fermée  
4. **Utiliser `flutter_local_notifications`** pour afficher les notifications en foreground  
5. **Le handler background** doit être une fonction top-level (pas une méthode de classe)

### Crashlytics

1. **Initialiser Crashlytics avant `runApp()`**  
2. **Capturer toutes les exceptions Flutter** avec `FlutterError.onError`  
3. **Ne jamais logger de données personnelles** dans les crashlytics  
4. **Ajouter le contexte métier** avec `setCustomKey()` pour faciliter le débogage

// Exemple : capturer les erreurs Flutter globalement

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  try {

    await Firebase.initializeApp(

      options: DefaultFirebaseOptions.currentPlatform,

    ).timeout(const Duration(seconds: 8));

    FlutterError.onError \= FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError \= (error, stack) {

      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);

      return true;

    };

  } catch (_) {

    // Firebase indisponible (timeout/erreur reseau) : l'app demarre quand meme

  }

  runApp(const MyApp());

}

### Performance et UI

1. **`const` constructors** sur tous les widgets statiques  
2. **`ListView.builder()`** à la place de `ListView()` pour les listes longues  
3. **`BlocSelector`** pour reconstruire uniquement la partie de l'UI concernée par un sous-état  
4. **`Future.wait()`** pour les appels parallèles (ne pas chaîner des `await` inutilement)  
5. **Éviter les rebuilds inutiles** — ne pas mettre de logique dans `build()`  
6. **Images** : utiliser `cached_network_image` pour le cache automatique

### Tests

1. **Tests unitaires** pour tous les BLoC (`bloc_test`)  
2. **Tests unitaires** pour les Repository (mocker `ApiClient`)  
3. **Tests de widgets** pour les composants partagés critiques  
4. **Mocktail** pour le mocking — pas de `mockito` manual  
5. **Nommer les tests en français** ou anglais, en snake\_case descriptif  
6. **Couvrir les cas** : succès, erreur réseau, liste vide, état chargement

### Logging

1. **Pas de `print()`** en production — utiliser un logger structuré  
2. **Crashlytics** pour les erreurs critiques  
3. **Ne jamais logger** : tokens, mots de passe, données personnelles  
4. **`debugPrint()`** uniquement en développement

---

## Injection de Dépendances (get\_it)

// lib/core/di/injection\_container.dart

import 'package:get\_it/get\_it.dart';

import '../network/api\_client.dart';

import '../../features/commandes/data/repositories/commande\_repository.dart';

import '../../features/commandes/presentation/bloc/commande\_bloc.dart';

// ... autres imports

final sl \= GetIt.instance;

Future\<void\> init() async {

  // ── Core ──────────────────────────────────────────────────

  sl.registerLazySingleton\<ApiClient\>(() \=\> ApiClient());

  sl.registerLazySingleton\<KeycloakService\>(() \=\> KeycloakService());

  sl.registerLazySingleton\<NotificationService\>(() \=\> NotificationService());

  // ── Repositories ──────────────────────────────────────────

  sl.registerLazySingleton\<CommandeRepository\>(

      () \=\> CommandeRepository(sl\<ApiClient\>()));

  sl.registerLazySingleton\<TissuRepository\>(

      () \=\> TissuRepository(sl\<ApiClient\>()));

  sl.registerLazySingleton\<ModeleRepository\>(

      () \=\> ModeleRepository(sl\<ApiClient\>()));

  sl.registerLazySingleton\<UtilisateurRepository\>(

      () \=\> UtilisateurRepository(sl\<ApiClient\>()));

  // ── BLoCs (factory : nouvelle instance à chaque utilisation) ──

  sl.registerFactory\<CommandeBloc\>(

      () \=\> CommandeBloc(sl\<CommandeRepository\>()));

  sl.registerFactory\<TissuBloc\>(

      () \=\> TissuBloc(sl\<TissuRepository\>()));

  sl.registerFactory\<ModeleBloc\>(

      () \=\> ModeleBloc(sl\<ModeleRepository\>()));

}

// main.dart

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Firebase (optionnel, ne doit jamais bloquer le demarrage de l'app)

  try {

    await Firebase.initializeApp(

      options: DefaultFirebaseOptions.currentPlatform,

    ).timeout(const Duration(seconds: 8));

    // Crashlytics

    FlutterError.onError \= FirebaseCrashlytics.instance.recordFlutterFatalError;

  } catch (_) {

    // Firebase indisponible (timeout/erreur reseau) : l'app demarre quand meme

  }

  // Injection de dépendances

  await init();

  // Notifications

  await sl\<NotificationService\>().initialize();

  runApp(const MyApp());

}

---

## Navigation (go\_router)

// lib/core/router/app\_router.dart

import 'package:go\_router/go\_router.dart';

final appRouter \= GoRouter(

  initialLocation: '/login',

  redirect: (context, state) async {

    final isLoggedIn \= await sl\<KeycloakService\>().isLoggedIn();

    final isOnLogin \= state.matchedLocation \== '/login';

    if (\!isLoggedIn && \!isOnLogin) return '/login';

    if (isLoggedIn && isOnLogin) return '/home';

    return null;

  },

  routes: \[

    GoRoute(path: '/login',    builder: (\_, \_\_) \=\> const LoginPage()),

    GoRoute(path: '/home',     builder: (\_, \_\_) \=\> const HomePage()),

    GoRoute(path: '/commandes', builder: (\_, \_\_) \=\> BlocProvider(

      create: (\_) \=\> sl\<CommandeBloc\>()..add(const LoadCommandes()),

      child: const CommandeListPage(),

    )),

    GoRoute(path: '/tissus',   builder: (\_, \_\_) \=\> BlocProvider(

      create: (\_) \=\> sl\<TissuBloc\>()..add(const LoadTissus()),

      child: const TissuListPage(),

    )),

  \],

);

---

## Patterns à Utiliser

1. **BLoC Pattern** — séparation UI / logique métier  
2. **Repository Pattern** — abstraction de l'accès aux données  
3. **Dependency Injection** avec `get_it`  
4. **Clean Architecture** — domain / data / presentation  
5. **Singleton** pour `ApiClient` et `KeycloakService`  
6. **Factory** pour les BLoC (nouvelle instance par page)  
7. **Intercepteur Dio** pour le JWT automatique

---

## pubspec.yaml — Dépendances Standards

dependencies:

  flutter:

    sdk: flutter

  \# Firebase

  firebase\_core: ^2.24.0

  firebase\_messaging: ^14.7.6

  firebase\_crashlytics: ^3.4.8

  firebase\_analytics: ^10.7.4

  firebase\_remote\_config: ^4.3.8

  \# Auth (Keycloak)

  flutter\_secure\_storage: ^9.0.0

  jwt\_decoder: ^2.0.1

  intl\_phone\_field: ^3.2.0

  \# HTTP

  dio: ^5.3.3

  http: ^1.1.0

  \# Gestion d'état

  flutter\_bloc: ^8.1.3

  bloc: ^8.1.2

  equatable: ^2.0.5

  \# Navigation

  go\_router: ^13.0.0

  \# Injection de dépendances

  get\_it: ^7.6.4

  \# Notifications locales

  flutter\_local\_notifications: ^16.1.0

  \# Images

  cached\_network\_image: ^3.3.0

  \# Variables d'environnement

  flutter\_dotenv: ^5.1.0

dev\_dependencies:

  flutter\_test:

    sdk: flutter

  bloc\_test: ^9.1.5

  mocktail: ^1.0.1

  flutter\_lints: ^3.0.0

---

Toujours suivre ces patterns et conventions lors de la génération de code pour maintenir la cohérence avec l'architecture existante.  
