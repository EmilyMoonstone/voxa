import 'app_settings.dart';

abstract interface class AppPreferencesRepository {
  AppSettings load();
  Future<void> save(AppSettings settings);
  Future<void> clear();
}
