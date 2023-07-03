import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

class NotificationController {
  static void initialize() {
    AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: 'scheduled',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Scheduled notifications',
          importance: NotificationImportance.High,
        ),
      ],
    );
  }

  static Future<bool> requestNotificationPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  static void scheduleHabitNotification({
    int? habitId,
    required String habitName,
    required DateTime date,
  }) async {
    final random = Random();
    habitId ??= random.nextInt(999999); // Generate random ID if habitId is null

    final isAllowed = await requestNotificationPermission();
    if (!isAllowed) {
      // Handle the case when notification permission is not granted
      return;
    }

    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: habitId,
        channelKey: 'scheduled',
        title: '$habitName Habit Reminder',
        body: 'Remember to work on your $habitName habit',
      ),
      schedule: NotificationCalendar.fromDate(date: date),
    );
  }

  static void cancelHabitNotification(int habitId) {
    AwesomeNotifications().cancel(habitId);
  }
}
