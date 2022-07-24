import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_me/bloc/edit_bloc.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';

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
                  ? Text("Edit Reminder")
                  : Text("Add Reminder"),
            ),
            body: Column(children: [Text("meow")]),
          );
        },
      ),
    );
  }
}
