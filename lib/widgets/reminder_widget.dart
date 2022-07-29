import 'package:flutter/material.dart';
import 'package:remind_me/pages/editreminderpage.dart';

import '../data/models/reminder.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder reminder;
  final Function(bool)? onChanged;
  final Function()? onLongPress;
  const ReminderWidget(
      {Key? key, required this.reminder, this.onChanged, this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: reminder.enabled ? 1 : 0.4,
      duration: const Duration(milliseconds: 300),
      child: Card(
        color: Theme.of(context).colorScheme.surface,
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        child: InkWell(
          onTap: reminder.enabled
              ? () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditReminderPage(
                              initialReminder: reminder,
                            )),
                  )
              : null,
          onLongPress: reminder.enabled ? onLongPress : null,
          child: ListTile(
            leading: Icon(
              Icons.public,
              color: reminder.enabled
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline,
            ),
            title: Text(reminder.title ?? reminder.schedule.toString()),
            subtitle: reminder.title != null
                ? Text(reminder.schedule.toString())
                : null,
            trailing: Switch(
              value: reminder.enabled,
              onChanged: onChanged,
              activeColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
