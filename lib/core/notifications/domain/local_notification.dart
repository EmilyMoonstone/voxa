enum AppNotificationChannel {
  reminders(
    id: 'reminders',
    name: 'Reminders',
    description: 'Practice reminders and scheduled prompts.',
  );

  const AppNotificationChannel({
    required this.id,
    required this.name,
    required this.description,
  });

  final String id;
  final String name;
  final String description;
}

class LocalNotification {
  const LocalNotification({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
    this.channel = AppNotificationChannel.reminders,
  });

  final int id;
  final String title;
  final String body;
  final String? payload;
  final AppNotificationChannel channel;
}
