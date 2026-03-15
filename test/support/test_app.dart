import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxa/app/app_providers.dart';
import 'package:voxa/app/bootstrap/app_bootstrap.dart';
import 'package:voxa/core/data/local/app_database.dart';
import 'package:voxa/core/notifications/domain/local_notification.dart';
import 'package:voxa/core/notifications/domain/local_notifications_service.dart';
import 'package:voxa/features/settings/application/app_locale.dart';
import 'package:voxa/features/settings/domain/app_settings.dart';
import 'package:voxa/l10n/app_localizations.dart';

import 'fakes.dart';

Future<void> pumpLocalizedScope(
  WidgetTester tester, {
  required Widget child,
  AppSettings? initialSettings,
  List overrides = const [],
}) async {
  final resolvedSettings = initialSettings ?? AppSettings.defaults;
  SharedPreferences.setMockInitialValues(<String, Object>{
    'settings.locale': resolvedSettings.localeCode,
    'settings.theme_mode': resolvedSettings.themeMode.name,
    'settings.smoothing_window_ms': resolvedSettings.smoothingWindowMs,
    'settings.target_tolerance_hz': resolvedSettings.targetToleranceHz,
    'settings.target_volume_tolerance_db':
        resolvedSettings.targetVolumeToleranceDb,
    'settings.last_pitch_training_mode':
        resolvedSettings.lastPitchTrainingMode.storageValue,
    'settings.live_feedback_recording':
        resolvedSettings.showLiveFeedbackDuringRecording,
    'settings.updated_at_ms': resolvedSettings.updatedAt.millisecondsSinceEpoch,
  });
  final preferences = await SharedPreferences.getInstance();
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
  final database = AppDatabase.forTesting(NativeDatabase.memory());
  addTearDown(database.close);
  final bootstrap = AppBootstrap(
    preferences: preferences,
    database: database,
    localNotificationsService: _TestLocalNotificationsService(),
    initialSettings: resolvedSettings,
    initialLocation: '/',
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appBootstrapProvider.overrideWithValue(bootstrap),
        syncMetadataRepositoryProvider.overrideWithValue(
          FakeSyncMetadataRepository(),
        ),
        googleAccountServiceProvider.overrideWithValue(
          FakeGoogleAccountService(supported: false),
        ),
        syncServiceProvider.overrideWithValue(FakeSyncService()),
        ...overrides,
      ],
      child: MaterialApp(
        locale: resolvedSettings.localeCode == AppSettings.systemLocaleCode
            ? null
            : Locale(resolveEffectiveLocaleCode(resolvedSettings.localeCode)),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      ),
    ),
  );
}

class _TestLocalNotificationsService implements LocalNotificationsService {
  @override
  NotificationAppLaunchDetails? get launchDetails => null;

  @override
  Stream<NotificationResponse> get notificationResponses =>
      const Stream<NotificationResponse>.empty();

  @override
  Future<bool> areNotificationsEnabled() async => true;

  @override
  Future<void> cancel(int id) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<bool> canScheduleExactAlarms() async => true;

  @override
  Future<void> initialize() async {}

  @override
  Future<List<PendingNotificationRequest>>
  pendingNotificationRequests() async => const [];

  @override
  Future<bool> requestExactAlarmsPermission() async => true;

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> schedule({
    required LocalNotification notification,
    required DateTime scheduledAt,
  }) async {}

  @override
  Future<void> show(LocalNotification notification) async {}
}
