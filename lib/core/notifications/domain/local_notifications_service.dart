import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'local_notification.dart';

abstract interface class LocalNotificationsService {
  Stream<NotificationResponse> get notificationResponses;

  NotificationAppLaunchDetails? get launchDetails;

  Future<void> initialize();

  Future<bool> requestPermissions();

  Future<bool> areNotificationsEnabled();

  Future<bool> requestExactAlarmsPermission();

  Future<bool> canScheduleExactAlarms();

  Future<void> show(LocalNotification notification);

  Future<void> schedule({
    required LocalNotification notification,
    required DateTime scheduledAt,
  });

  Future<List<PendingNotificationRequest>> pendingNotificationRequests();

  Future<void> cancel(int id);

  Future<void> cancelAll();
}
