import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:url_launcher/url_launcher.dart';

/// A handler for the notification scheduling. Requires a [repository] to be initialized so it can react to [Reminder] changes
class NotificationHandler {
  final ReminderRepository repository;
  List<Reminder> reminders =
      []; // to keep track of changes in lieu of setting up event system
  static const String _channelKey = "reminder_channel";

  NotificationHandler(this.repository);

  /// Initialize the handler
  Future<bool> initialize() async {
    // initial reminder list to keep track of changes
    reminders = await repository.fetchReminders();

    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'Reminders',
          channelKey: _channelKey,
          channelName: 'Reminder Notifications',
          channelDescription: 'Notification channel for reminders',
          ledColor: Colors.white,
          vibrationPattern: mediumVibrationPattern,
          defaultRingtoneType: DefaultRingtoneType.Alarm,
          importance: NotificationImportance.High,
        ),
      ],
    );
    // On notification tapped, open the URL
    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) async {
      String url =
          receivedNotification.payload?["URL"] ?? "https://www.google.com/";
      if (!url.startsWith("https://")) {
        url = 'https://www.$url';
      }
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    });

    // On display of single notification, disable that reminder
    AwesomeNotifications()
        .displayedStream
        .listen((ReceivedNotification displayedNotification) async {
      if (displayedNotification.id != null) {
        try {
          Reminder reminder =
              await repository.fetchReminder(displayedNotification.id!);
          if (!reminder.schedule.repeating) {
            repository.editReminder(reminder.copyWith(enabled: false));
          }
        } catch (e) {
          print(e);
        }
      }
    });

    repository.reminders.listen((event) async {
      // TODO: probably would've been better to have had a whole event system for add, remove, edit, etc.

      // compare the lists of reminders to see what's changed
      List<Reminder> newOnes = event
          .toSet()
          .difference(reminders.toSet())
          .toList(); // new/edited reminders
      List<Reminder> deletedOnes = reminders
          .toSet()
          .difference(event.toSet())
          .toList(); // deleted reminders

      // if a reminder is edited, it will be in both new and deleted,
      // with the one in deleted being the old value and the one in new being the new value

      // update local reminder list
      reminders = event;

      // remove all deleted reminder notification schedules
      for (Reminder reminder in deletedOnes) {
        // can delete if ID not in newOnes
        final int index = newOnes.indexWhere((element) {
          if (element.id != null && element.id == reminder.id) {
            return true;
          }
          return false;
        });
        if (reminder.id != null && index < 0) {
          await AwesomeNotifications().cancel(reminder.id!);
        }
      }

      // schedule all new/edited reminders
      for (Reminder reminder in newOnes) {
        // only schedule reminders that should be scheduled
        if (reminder.id != null && reminder.enabled == true) {
          bool created = await AwesomeNotifications().createNotification(
              content: NotificationContent(
                  wakeUpScreen: true,
                  displayOnBackground: true,
                  displayOnForeground: true,
                  id: reminder.id!,
                  channelKey: _channelKey,
                  title: reminder.title ?? reminder.payload.toString(),
                  body: "Don't forget about this reminder!",
                  payload: {"URL": reminder.payload.toString()}),
              schedule: NotificationCalendar(
                  repeats: reminder.schedule.repeating,
                  minute: reminder.schedule.minute,
                  hour: reminder.schedule.hour,
                  day: reminder.schedule.day,
                  weekday: reminder.schedule.weekday,
                  month: reminder.schedule.month,
                  year: reminder.schedule.year,
                  second: 0,
                  preciseAlarm: true));
          // disable reminder if couldn't create
          if (!created) {
            repository.editReminder(reminder.copyWith(enabled: false));
          }
        }
      }
    });
    return true;
  }

  /// Alert the user if the required permissions are not met
  static Future<bool> checkPermissions(BuildContext context) async {
    if (kIsWeb) {
      return true;
    }

    // check permissions
    List<NotificationPermission> permissionList = const [
      NotificationPermission.Alert,
      NotificationPermission.Sound,
      NotificationPermission.Vibration,
      NotificationPermission.Light,
      NotificationPermission.PreciseAlarms
    ];
    List<NotificationPermission> permissionsAllowed =
        await AwesomeNotifications().checkPermissionList(
            channelKey: _channelKey, permissions: permissionList);

    if (permissionList.length == permissionsAllowed.length) {
      return true;
    }

    // request permissions that aren't allowed

    // figure out the missing permissions
    List<NotificationPermission> permissionsNeeded =
        permissionList.toSet().difference(permissionsAllowed.toSet()).toList();

    // Check if app needs to show rationale for permissions
    List<NotificationPermission> lockedPermissions =
        await AwesomeNotifications().shouldShowRationaleToRequest(
            channelKey: _channelKey, permissions: permissionsNeeded);

    // If not, request permissions
    if (lockedPermissions.isEmpty) {
      await AwesomeNotifications().requestPermissionToSendNotifications(
          channelKey: _channelKey, permissions: permissionsNeeded);
    } else {
      // show dialogue explaining that the user needs to enable permissions
      await showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text(
                  'Permission needed',
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'To proceed, you need to enable the following permissions:',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                        lockedPermissions
                            .join(', ')
                            .replaceAll('NotificationPermission.', ''),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Deny',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      )),
                  ElevatedButton(
                    onPressed: () async {
                      // Request the permission through native resources
                      await AwesomeNotifications()
                          .requestPermissionToSendNotifications(
                              channelKey: _channelKey,
                              permissions: lockedPermissions);

                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Allow',
                    ),
                  ),
                ],
              ));
    }

    // Check if the permissions have been successfully enabled
    permissionsAllowed = await AwesomeNotifications().checkPermissionList(
        channelKey: _channelKey, permissions: permissionsNeeded);

    return permissionsAllowed.length == permissionsNeeded.length;
  }
}
