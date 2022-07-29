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
        ..add(const LoadHomeEvent([], null))),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: state.selected != null
                  ? IconButton(
                      onPressed: () {
                        context.read<HomeBloc>().add(
                            ToggleSelectView(state.reminders, state.selected));
                      },
                      icon: const Icon(Icons.arrow_back),
                      splashRadius: Material.defaultSplashRadius / 2,
                    )
                  : null,
              title: state.selected == null
                  ? const Text("Reminders")
                  : Text("${state.selected!.length} selected"),
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
                    // if not in select view, enable/disable reminder
                    // if in selectview, select or deselect item
                    onTap: state.selected == null
                        ? state.reminders[index].enabled
                            ? () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditReminderPage(
                                            initialReminder:
                                                state.reminders[index],
                                          )),
                                )
                            : null
                        : () {},
                    onLongPress: () {
                      // only toggle select view when select view disabled
                      if (state.selected == null) {
                        context.read<HomeBloc>().add(
                            ToggleSelectView(state.reminders, state.selected));
                      }
                    },
                    onChanged: (result) => context.read<HomeBloc>().add(
                        EditReminder(
                            state.reminders[index].copyWith(enabled: result),
                            state.reminders,
                            null)),
                  );
                })),
          );
        },
      ),
    );
  }
}
