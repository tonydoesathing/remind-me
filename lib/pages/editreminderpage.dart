import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_me/bloc/edit_bloc.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:remind_me/data/tools/schedule_utils.dart';
import 'package:remind_me/widgets/clearable_textfield.dart';

class EditReminderPage extends StatelessWidget {
  final Reminder? initialReminder;
  const EditReminderPage({Key? key, this.initialReminder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) =>
          EditBloc(initialReminder, context.read<ReminderRepository>())),
      child: BlocConsumer<EditBloc, EditState>(
        listener: (context, state) {
          if (state is EditSaving) {
            // display loading
          } else if (state is EditSaveSuccessful) {
            // navigate back to home
          } else if (state is EditSaveFailure) {
            // give error message
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: state.initialReminder != null
                  ? const Text("Edit Reminder")
                  : const Text("Add Reminder"),
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClearableTextField(
                  initialValue: state.initialReminder?.title,
                  errorText:
                      state is EditSaveFailure ? state.error.titleError : null,
                  label: "Title",
                  onChanged: (value) {
                    context.read<EditBloc>().add(UpdateLocalReminderEvent(value,
                        state.url, state.schedule, state.initialReminder));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClearableTextField(
                  initialValue: state.initialReminder?.title,
                  label: "URL",
                  prefix: Icon(Icons.public),
                  errorText: state is EditSaveFailure
                      ? state.error.payloadError
                      : null,
                  onChanged: (value) {
                    context.read<EditBloc>().add(UpdateLocalReminderEvent(
                        state.title,
                        value,
                        state.schedule,
                        state.initialReminder));
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: TextEditingController(
                      text:
                          "${state.schedule.hour}:${state.schedule.minute! < 10 ? 0 : ""}${state.schedule.minute}"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    errorText:
                        state is EditSaveFailure ? state.error.timeError : null,
                    labelText: "Time",
                    prefixIcon: const Icon(Icons.access_time),
                  ),
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay(
                            hour: state.schedule.hour ?? 0,
                            minute: state.schedule.minute ?? 0));
                    context.read<EditBloc>().add(UpdateLocalReminderEvent(
                        state.title,
                        state.url,
                        state.schedule
                            .copyWith(minute: time?.minute, hour: time?.hour),
                        state.initialReminder));
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      decoration: const InputDecoration(
                          label: Text("Repeat"), border: OutlineInputBorder()),
                      items: ["Once", "Daily", "Weekly", "Monthly", "Yearly"]
                          .map((String category) {
                        return DropdownMenuItem(
                            value: category, child: Text(category));
                      }).toList(),
                      onChanged: (newValue) {
                        // create schedule with correct properties
                        if (state.schedule.repetition != newValue) {
                          Schedule schedule;
                          if (newValue == "Once") {
                            // take state.schedule's hour and minute
                            // if state.schedule's day/month/year are null, set that to today
                            DateTime now = DateTime.now();
                            schedule = Schedule(
                                repeating: false,
                                minute: state.schedule.minute,
                                hour: state.schedule.hour,
                                day: state.schedule.day ?? now.day,
                                month: state.schedule.month ?? now.month,
                                year: now.year);
                          } else if (newValue == "Daily") {
                            // take state.schedule's hour and minute
                            // make everything else null
                            schedule = Schedule(
                                repeating: true,
                                minute: state.schedule.minute,
                                hour: state.schedule.hour);
                          } else if (newValue == "Weekly") {
                            // take state.schedule's hour and minute
                            // put in today's weekday
                            // make everything else null
                            DateTime now = DateTime.now();
                            schedule = Schedule(
                                repeating: true,
                                minute: state.schedule.minute,
                                hour: state.schedule.hour,
                                weekday: now.weekday);
                          } else if (newValue == "Monthly") {
                            // take state.schedule's hour and minute
                            // if state.schedule's day is null, set that to today; else copy
                            // make everything else null
                            DateTime now = DateTime.now();
                            schedule = Schedule(
                              repeating: true,
                              minute: state.schedule.minute,
                              hour: state.schedule.hour,
                              day: state.schedule.day ?? now.day,
                            );
                          } else if (newValue == "Yearly") {
                            // take state.schedule's hour and minute
                            // if state.schedule's day/month are null, set that to today; else copy
                            // make everything else null
                            DateTime now = DateTime.now();
                            schedule = Schedule(
                              repeating: true,
                              minute: state.schedule.minute,
                              hour: state.schedule.hour,
                              day: state.schedule.day ?? now.day,
                              month: state.schedule.month ?? now.month,
                            );
                          } else {
                            DateTime now = DateTime.now();
                            schedule = Schedule(
                                repeating: false,
                                minute: state.schedule.minute,
                                hour: state.schedule.hour,
                                day: now.day,
                                month: now.month,
                                year: now.year);
                          }
                          context.read<EditBloc>().add(UpdateLocalReminderEvent(
                              state.title,
                              state.url,
                              schedule,
                              state.initialReminder));
                        }
                      },
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      value: state.schedule.repetition,
                    ),
                  )),
              // if once or yearly, show date picker
              if (state.schedule.repetition == "Once")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(
                        text:
                            "${state.schedule.month}/${state.schedule.day}/${state.schedule.year}"),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Day",
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(
                              "${state.schedule.year}-${state.schedule.month! < 10 ? 0 : ""}${state.schedule.month}-${state.schedule.day! < 10 ? 0 : ""}${state.schedule.day}"),
                          firstDate: DateTime.parse("19700101"),
                          lastDate: DateTime.parse("20500101"));
                      if (date != null) {
                        context.read<EditBloc>().add(UpdateLocalReminderEvent(
                            state.title,
                            state.url,
                            state.schedule.copyWith(
                                day: date.day,
                                month: date.month,
                                year: date.year),
                            state.initialReminder));
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              // if weekly, give days of the week
              if (state.schedule.repetition == "Weekly")
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButtonFormField(
                        decoration: const InputDecoration(
                            label: Text("Day"), border: OutlineInputBorder()),
                        items: [
                          "Monday",
                          "Tuesday",
                          "Wednesday",
                          "Thursday",
                          "Friday",
                          "Saturday",
                          "Sunday"
                        ].map((String category) {
                          return DropdownMenuItem(
                              value: category, child: Text(category));
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            context.read<EditBloc>().add(
                                UpdateLocalReminderEvent(
                                    state.title,
                                    state.url,
                                    state.schedule.copyWith(
                                        weekday: ScheduleUtils()
                                            .stringToDay(newValue)),
                                    state.initialReminder));
                          }
                        },
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        value: ScheduleUtils()
                            .dayToString(state.schedule.weekday ?? 1),
                      ),
                    )),
              // if monthly, give day of month
              if (state.schedule.repetition == "Monthly")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(
                        text:
                            "${ScheduleUtils().dayToQualifierString(state.schedule.day!)} of every month"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Day",
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(
                              "${DateTime.now().year}-${DateTime.now().month < 10 ? 0 : ""}${DateTime.now().month}-${state.schedule.day! < 10 ? 0 : ""}${state.schedule.day}"),
                          firstDate: DateTime.parse("19700101"),
                          lastDate: DateTime.parse("20500101"));
                      if (date != null) {
                        context.read<EditBloc>().add(UpdateLocalReminderEvent(
                            state.title,
                            state.url,
                            state.schedule.copyWith(day: date.day),
                            state.initialReminder));
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),
              if (state.schedule.repetition == "Yearly")
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: TextEditingController(
                        text: "${state.schedule.month}/${state.schedule.day}"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Day",
                      prefixIcon: Icon(Icons.calendar_month),
                    ),
                    onTap: () async {
                      DateTime? date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.parse(
                              "${DateTime.now().year}-${state.schedule.month! < 10 ? 0 : ""}${state.schedule.month}-${state.schedule.day! < 10 ? 0 : ""}${state.schedule.day}"),
                          firstDate: DateTime.parse("19700101"),
                          lastDate: DateTime.parse("20500101"));
                      if (date != null) {
                        context.read<EditBloc>().add(UpdateLocalReminderEvent(
                            state.title,
                            state.url,
                            state.schedule
                                .copyWith(day: date.day, month: date.month),
                            state.initialReminder));
                      }
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                ),

              Center(
                child: FloatingActionButton(
                  onPressed: state is EditSaveFailure ? null : () {},
                  disabledElevation: 0,
                  child: const Icon(Icons.check),
                ),
              )
            ]),
          );
        },
      ),
    );
  }
}
