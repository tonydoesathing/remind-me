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
                  ? const Text("Edit Reminder")
                  : const Text("Add Reminder"),
            ),
            body: Column(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Title",
                      suffix: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        customBorder: CircleBorder(),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "URL",
                      prefixIcon: Icon(Icons.public),
                      suffix: InkWell(
                        onTap: () {},
                        child: Icon(
                          Icons.cancel_outlined,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        customBorder: CircleBorder(),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Time",
                    prefixIcon: Icon(Icons.access_time),
                    suffix: InkWell(
                      onTap: () {},
                      child: Icon(
                        Icons.cancel_outlined,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      customBorder: CircleBorder(),
                    ),
                  ),
                  onTap: () async {
                    TimeOfDay? time = await showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                    print(time);
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                ),
              ),
              Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButtonFormField(
                      decoration: InputDecoration(
                          label: Text("Repeat"), border: OutlineInputBorder()),
                      items: ["Once", "Daily", "Weekly", "Monthly", "Yearly"]
                          .map((String category) {
                        return DropdownMenuItem(
                            value: category, child: Text(category));
                      }).toList(),
                      onChanged: (newValue) {},
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      value: "Once",
                    ),
                  ))
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: FormField<String>(
              //     builder: (FormFieldState<String> state) {
              //       return InputDecorator(
              //         decoration: InputDecoration(
              //             labelText: "Repeat",
              //             hintText: 'Please select expense',
              //             border: OutlineInputBorder(
              //                 borderRadius: BorderRadius.circular(5.0))),
              //         child: DropdownButtonHideUnderline(
              //           child: DropdownButton<String>(
              //             value: "Once",
              //             isDense: true,
              //             onChanged: (value) {
              //               print(value);
              //             },
              //             onTap: () {
              //               FocusScope.of(context).requestFocus(FocusNode());
              //             },
              //             items: [
              //               "Once",
              //               "Daily",
              //               "Weekly",
              //               "Monthly",
              //               "Yearly"
              //             ].map((String value) {
              //               return DropdownMenuItem<String>(
              //                 value: value,
              //                 child: Text(value),
              //               );
              //             }).toList(),
              //           ),
              //         ),
              //       );
              //     },
              //   ),
              // )
              // Padding(
              //   padding: EdgeInsets.all(8.0),
              //   child: DropdownButtonFormField(
              //       hint: Text("Meow"),
              //       onChanged: (value) {
              //         print(value);
              //       },
              //       items: <String>['One', 'Two', 'Free', 'Four']
              //           .map<DropdownMenuItem<String>>((String value) {
              //         return DropdownMenuItem<String>(
              //           value: value,
              //           child: Text(value),
              //         );
              //       }).toList()),
              // ),
            ]),
          );
        },
      ),
    );
  }
}
