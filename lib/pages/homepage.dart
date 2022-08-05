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
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.error,
                    title: const Text("Error!"),
                    titleTextStyle: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(
                            color: Theme.of(context).colorScheme.onError),
                    content: Text(
                      state.error.toString(),
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onError),
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Ok"))
                    ],
                  );
                });
          }
        },
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
              actions: state.selected != null
                  ? [
                      IconButton(
                        onPressed: () {
                          context.read<HomeBloc>().add(ToggleSelectAllReminders(
                              state.reminders, state.selected));
                        },
                        icon: const Icon(Icons.select_all),
                        splashRadius: Material.defaultSplashRadius / 2,
                      )
                    ]
                  : null,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: state.selected == null
                ? FloatingActionButton(
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
                  )
                : null,
            bottomNavigationBar: state.selected != null
                ? BottomAppBar(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        // Foreground color
                                        onPrimary: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        // Background color
                                        primary: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ).copyWith(
                                          elevation:
                                              ButtonStyleButton.allOrNull(0.0)),
                                      onPressed: () {
                                        context.read<HomeBloc>().add(
                                            ToggleSelectedReminders(
                                                state.reminders,
                                                state.selected,
                                                true));
                                      },
                                      icon: const Icon(Icons.alarm),
                                      label: const Text("Turn on")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        // Foreground color
                                        onPrimary: Theme.of(context)
                                            .colorScheme
                                            .onSecondaryContainer,
                                        // Background color
                                        primary: Theme.of(context)
                                            .colorScheme
                                            .secondaryContainer,
                                      ).copyWith(
                                          elevation:
                                              ButtonStyleButton.allOrNull(0.0)),
                                      onPressed: () {
                                        context.read<HomeBloc>().add(
                                            ToggleSelectedReminders(
                                                state.reminders,
                                                state.selected,
                                                false));
                                      },
                                      icon: const Icon(Icons.alarm_off),
                                      label: const Text("Turn off")),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FloatingActionButton.small(
                              onPressed: () async {
                                if (state.selected!.isNotEmpty) {
                                  bool? result = await showDialog<bool?>(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: const Text(
                                            "Delete selected reminders?"),
                                        content: const Text(
                                            "If you delete them they'll be gone forever!"),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true),
                                              child: const Text("Delete")),
                                          ElevatedButton(
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false),
                                              style: ElevatedButton.styleFrom(
                                                // Foreground color
                                                onPrimary: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                // Background color
                                                primary: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ).copyWith(
                                                  elevation: ButtonStyleButton
                                                      .allOrNull(0.0)),
                                              child: const Text("Cancel"))
                                        ],
                                      );
                                    },
                                  );
                                  if (result != null && result) {
                                    context.read<HomeBloc>().add(
                                        RemoveSelectedReminders(
                                            state.reminders, state.selected));
                                  }
                                }
                              },
                              elevation: 0,
                              focusElevation: 0,
                              hoverElevation: 0,
                              highlightElevation: 0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                              child: const Icon(Icons.delete_forever_outlined),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : null,
            body: ListView.builder(
                itemCount: state.reminders.length,
                itemBuilder: ((context, index) {
                  return ReminderWidget(
                    reminder: state.reminders[index],
                    selectView: state.selected != null,
                    selected: state.selected?.contains(state.reminders[index]),
                    onToggleSelect: () {
                      context.read<HomeBloc>().add(ToggleSelectReminder(
                          state.reminders[index],
                          state.reminders,
                          state.selected));
                    },
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
                        context.read<HomeBloc>().add(ToggleSelectView(
                            state.reminders, state.selected,
                            reminder: state.reminders[index]));
                      }
                    },
                    onToggleEnabled: (result) => context.read<HomeBloc>().add(
                        ToggleReminderEnabled(
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
