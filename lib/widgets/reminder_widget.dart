import 'package:flutter/material.dart';
import 'package:remind_me/pages/editreminderpage.dart';

import '../data/models/reminder.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder reminder;
  final Function(bool)? onToggleEnabled;
  final Function()? onLongPress;
  final Function()? onTap;
  final bool selectView;
  final bool? selected;
  final Function(bool?)? onToggleSelect;

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
        if (selectView)
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Checkbox(value: selected, onChanged: onToggleSelect),
          ),
        Expanded(
          child: AnimatedOpacity(
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
                onTap: onTap,
                onLongPress: reminder.enabled ? onLongPress : null,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
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
                          reminder.title ?? reminder.schedule.toString(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          reminder.title != null
                              ? reminder.schedule.toString()
                              : "null",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      ],
                    )),
                    Container(
                        width: 80,
                        height: 80,
                        child: Center(
                            child: Switch(
                                value: reminder.enabled,
                                onChanged: onToggleEnabled,
                                activeColor:
                                    Theme.of(context).colorScheme.primary))),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
    // return AnimatedOpacity(
    //   opacity: reminder.enabled ? 1 : 0.4,
    //   duration: const Duration(milliseconds: 300),
    //   child: Card(
    //     color: Theme.of(context).colorScheme.surface,
    //     clipBehavior: Clip.antiAlias,
    //     elevation: 0,
    //     shape: RoundedRectangleBorder(
    //       side: BorderSide(
    //         color: Theme.of(context).colorScheme.outline,
    //       ),
    //       borderRadius: const BorderRadius.all(Radius.circular(12)),
    //     ),
    //     child: InkWell(
    //       onTap: onTap,
    //       onLongPress: reminder.enabled ? onLongPress : null,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         children: [
    //           Container(
    //               width: 80,
    //               height: 80,
    //               child: Center(
    //                   child: Icon(
    //                 Icons.public,
    //                 color: reminder.enabled
    //                     ? Theme.of(context).colorScheme.primary
    //                     : Theme.of(context).colorScheme.outline,
    //               ))),
    //           Expanded(
    //               child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 reminder.title ?? reminder.schedule.toString(),
    //                 style: Theme.of(context).textTheme.titleMedium,
    //               ),
    //               Text(
    //                 reminder.title != null
    //                     ? reminder.schedule.toString()
    //                     : "null",
    //                 style: Theme.of(context).textTheme.bodyMedium,
    //               )
    //             ],
    //           )),
    //           Container(
    //               width: 80,
    //               height: 80,
    //               child: Center(
    //                   child: Switch(
    //                       value: reminder.enabled,
    //                       onChanged: onChanged,
    //                       activeColor: Theme.of(context).colorScheme.primary))),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
