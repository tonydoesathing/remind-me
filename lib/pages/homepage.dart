import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_me/bloc/home_bloc.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:remind_me/pages/editreminderpage.dart';
import 'package:remind_me/widgets/reminder_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) => HomeBloc(context.read<ReminderRepository>())
        ..add(const LoadHomeEvent([]))),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Reminders"),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              onPressed: (() {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditReminderPage()),
                );
              }),
              child: const Icon(Icons.add),
            ),
            body: ListView.builder(
                itemCount: state.reminders.length,
                itemBuilder: ((context, index) {
                  return ReminderWidget(
                    reminder: state.reminders[index],
                    onLongPress: () => print("meow"),
                    onChanged: (result) => context.read<HomeBloc>().add(
                        EditReminder(
                            state.reminders[index].copyWith(enabled: result),
                            state.reminders)),
                  );
                })),
          );
        },
      ),
    );
  }
}