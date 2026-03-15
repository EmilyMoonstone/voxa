import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/data/local/app_database.dart';
import '../../core/notifications/domain/local_notifications_service.dart';
import '../../features/settings/domain/app_settings.dart';

class AppBootstrap {
  const AppBootstrap({
    required this.preferences,
    required this.database,
    required this.localNotificationsService,
    required this.initialSettings,
    required this.initialLocation,
  });

  final SharedPreferences preferences;
  final AppDatabase database;
  final LocalNotificationsService localNotificationsService;
  final AppSettings initialSettings;
  final String initialLocation;
}

final appBootstrapProvider = Provider<AppBootstrap>(
  (ref) => throw UnimplementedError('AppBootstrap override missing'),
);

final sharedPreferencesProvider = Provider<SharedPreferences>(
  (ref) => ref.watch(appBootstrapProvider).preferences,
);

final appDatabaseProvider = Provider<AppDatabase>(
  (ref) => ref.watch(appBootstrapProvider).database,
);

final localNotificationsServiceProvider = Provider<LocalNotificationsService>(
  (ref) => ref.watch(appBootstrapProvider).localNotificationsService,
);

final initialLocationProvider = Provider<String>(
  (ref) => ref.watch(appBootstrapProvider).initialLocation,
);
