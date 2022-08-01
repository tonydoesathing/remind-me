import 'package:flutter/material.dart';
import 'package:remind_me/data/tools/schedule_utils.dart';
import 'package:remind_me/pages/editreminderpage.dart';

import '../data/models/reminder.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder reminder;
  final Function(bool)? onToggleEnabled;
  final Function()? onLongPress;
  final Function()? onTap;
  final bool selectView;
  final bool? selected;
  final Function()? onToggleSelect;

  const ReminderWidget(
      {Key? key,
      required this.reminder,
      this.onToggleEnabled,
      this.onTap,
      this.onLongPress,
      this.selectView = false,
      this.selected,
      this.onToggleSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: selectView ? 40 : 0,
          height: selectView ? 40 : 0,
          curve: Curves.easeIn,
          child: selectView
              ? Checkbox(
                  activeColor: Theme.of(context).colorScheme.primary,
                  value: selected ?? false,
                  onChanged: (val) => onToggleSelect?.call(),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                )
              : null,
        ),
        Expanded(
          child: AnimatedOpacity(
            opacity: reminder.enabled ? 1 : 0.4,
            duration: const Duration(milliseconds: 300),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: Card(
                color: Theme.of(context).colorScheme.surface,
                clipBehavior: Clip.antiAlias,
                elevation: selectView
                    ? selected!
                        ? 5
                        : 0
                    : 0,
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                ),
                child: InkWell(
                  onTap: selectView ? onToggleSelect : onTap,
                  onLongPress: onLongPress,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                              child: Icon(
                            Icons.public,
                            color: reminder.enabled
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.outline,
                          ))),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reminder.title ?? reminder.payload,
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            ScheduleUtils().parseSchedule(reminder.schedule),
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
                      )),
                      SizedBox(
                          width: 80,
                          height: 80,
                          child: Center(
                              child: Switch(
                                  value: reminder.enabled,
                                  onChanged: selectView
                                      ? (val) => onToggleSelect?.call()
                                      : onToggleEnabled,
                                  activeColor:
                                      Theme.of(context).colorScheme.primary))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
