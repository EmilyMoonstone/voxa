import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/local_notification.dart';
import '../domain/local_notifications_service.dart';

const _windowsAppGuid = '4b3c7f4d-4db4-4d70-a45c-0fc8f1c18a8c';
const _remindersChannelId = 'reminders';
const _remindersChannelName = 'Reminders';
const _remindersChannelDescription =
    'Practice reminders and scheduled prompts.';

class FlutterLocalNotificationsService implements LocalNotificationsService {
  FlutterLocalNotificationsService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  final StreamController<NotificationResponse> _notificationResponses =
      StreamController<NotificationResponse>.broadcast();

  NotificationAppLaunchDetails? _launchDetails;
  bool _initialized = false;

  static const AndroidNotificationChannel _remindersChannel =
      AndroidNotificationChannel(
        _remindersChannelId,
        _remindersChannelName,
        description: _remindersChannelDescription,
        importance: Importance.high,
      );

  @override
  Stream<NotificationResponse> get notificationResponses =>
      _notificationResponses.stream;

  @override
  NotificationAppLaunchDetails? get launchDetails => _launchDetails;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _launchDetails = await _plugin.getNotificationAppLaunchDetails();
    tz_data.initializeTimeZones();
    await _configureLocalTimeZone();

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      macOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
      linux: LinuxInitializationSettings(defaultActionName: 'Open'),
      windows: WindowsInitializationSettings(
        appName: 'Voxa',
        appUserModelId: 'BruckCode.Voxa.App.0.1',
        guid: _windowsAppGuid,
      ),
    );

    await _plugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _notificationResponses.add,
    );
    await _createAndroidChannels();
    _initialized = true;
  }

  @override
  Future<bool> requestPermissions() async {
    await initialize();

    var granted = true;
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final macosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();

    final androidGranted = await androidPlugin
        ?.requestNotificationsPermission();
    if (androidGranted != null) {
      granted = granted && androidGranted;
    }

    final iosGranted = await iosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (iosGranted != null) {
      granted = granted && iosGranted;
    }

    final macosGranted = await macosPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (macosGranted != null) {
      granted = granted && macosGranted;
    }

    return granted;
  }

  @override
  Future<bool> areNotificationsEnabled() async {
    await initialize();

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final macosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();

    final androidEnabled = await androidPlugin?.areNotificationsEnabled();
    if (androidEnabled != null) {
      return androidEnabled;
    }

    final iosPermissions = await iosPlugin?.checkPermissions();
    if (iosPermissions != null) {
      return iosPermissions.isEnabled;
    }

    final macosPermissions = await macosPlugin?.checkPermissions();
    if (macosPermissions != null) {
      return macosPermissions.isEnabled;
    }

    return true;
  }

  @override
  Future<bool> requestExactAlarmsPermission() async {
    await initialize();

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await androidPlugin?.requestExactAlarmsPermission() ?? true;
  }

  @override
  Future<bool> canScheduleExactAlarms() async {
    await initialize();

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await androidPlugin?.canScheduleExactNotifications() ?? true;
  }

  @override
  Future<void> show(LocalNotification notification) async {
    await initialize();
    await _plugin.show(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      notificationDetails: _notificationDetails(notification.channel),
      payload: notification.payload,
    );
  }

  @override
  Future<void> schedule({
    required LocalNotification notification,
    required DateTime scheduledAt,
  }) async {
    await initialize();
    final scheduleMode = await _androidScheduleMode();
    await _plugin.zonedSchedule(
      id: notification.id,
      title: notification.title,
      body: notification.body,
      scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
      notificationDetails: _notificationDetails(notification.channel),
      payload: notification.payload,
      androidScheduleMode: scheduleMode,
    );
  }

  @override
  Future<List<PendingNotificationRequest>> pendingNotificationRequests() async {
    await initialize();
    return _plugin.pendingNotificationRequests();
  }

  @override
  Future<void> cancel(int id) async {
    await initialize();
    await _plugin.cancel(id: id);
  }

  @override
  Future<void> cancelAll() async {
    await initialize();
    await _plugin.cancelAll();
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      final timezoneInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneInfo.identifier));
    } catch (error, stackTrace) {
      debugPrint(
        'Failed to configure local timezone for notifications: $error',
      );
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_remindersChannel);
  }

  Future<AndroidScheduleMode> _androidScheduleMode() async {
    final canScheduleExact = await canScheduleExactAlarms();
    return canScheduleExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  NotificationDetails _notificationDetails(AppNotificationChannel channel) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(),
      macOS: const DarwinNotificationDetails(),
      linux: const LinuxNotificationDetails(),
      windows: const WindowsNotificationDetails(),
    );
  }
}
