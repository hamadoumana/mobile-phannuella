# tailor_shop_mobile

Application mobile Flutter du projet **TailorShop** (gestion des clients, mesures et commandes
pour les ateliers de couture). Consomme l'API backend .NET 8 via `/api/v1/`.

Stack et conventions : voir `.specify/memory/constitution.md` (Principe VI) et
`.specify/templates/STANDARDS.md` (section 15) a la racine du repo, ainsi que
`copilot-instructions-flutter.md` dans ce dossier pour les patterns de code detailles.

## Architecture

Clean Architecture + BLoC Pattern :

```
lib/
  core/       constants, errors, network (ApiClient/KeycloakService), theme, utils, di, router
  features/
    auth/           presentation/bloc (Keycloak login/logout)
    clients/        data/domain/presentation (feature de reference)
    home/           presentation
  shared/     widgets et extensions communs
```

## Demarrage

1. Copier le fichier d'environnement :
   ```
   cp .env.example .env
   ```
   puis renseigner `API_BASE_URL` et les variables `KEYCLOAK_*` (voir votre realm Keycloak).

2. Installer les dependances :
   ```
   flutter pub get
   ```

3. (Optionnel, requis pour FCM/Crashlytics/Analytics/Remote Config) Configurer Firebase :
   ```
   flutterfire configure
   ```
   Cela genere `lib/firebase_options.dart` (non commite). Decommenter ensuite les blocs
   `TODO(FIREBASE)` dans `lib/main.dart`.

4. Lancer l'app :
   ```
   flutter run
   ```

## Tests

```
flutter test
```

`flutter_test` + `bloc_test` + `mocktail`. Voir `test/features/clients/bloc/client_bloc_test.dart`
pour l'exemple de reference a suivre pour chaque nouveau BLoC.

## Regles cles

- Aucun appel HTTP direct depuis un Widget -- toujours `Bloc` -> `Repository` -> `ApiClient`.
- Authentification exclusivement via Keycloak (`firebase_auth` interdit).
- Tokens stockes avec `flutter_secure_storage`, jamais loggees.
- `.env` et `lib/firebase_options.dart` ne doivent jamais etre commites.
