import 'dart:developer';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:remind_me/bloc/home_bloc.dart';
import 'package:remind_me/bloc/test_bloc_bloc.dart';
import 'package:remind_me/data/models/reminder.dart';
import 'package:remind_me/data/models/schedule.dart';
import 'package:remind_me/data/repositories/local_reminder_repository.dart';
import 'package:remind_me/data/repositories/reminder_repository.dart';
import 'package:remind_me/pages/homepage.dart';
import 'package:remind_me/widgets/reminder_widget.dart';

void main() {
  runApp(App(reminderRepository: LocalReminderRepository()));
}

const _brandPrimary = Color(0xFF4F57A9);

class App extends StatelessWidget {
  final ReminderRepository reminderRepository;
  const App({Key? key, required this.reminderRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
        value: reminderRepository,
        child: DynamicColorBuilder(
          builder: ((lightDynamic, darkDynamic) {
            ColorScheme lightColorScheme;
            ColorScheme darkColorScheme;

            if (lightDynamic != null && darkDynamic != null) {
              lightColorScheme = lightDynamic.harmonized();

              darkColorScheme = darkDynamic.harmonized();
            } else {
              // Otherwise, use fallback schemes.
              lightColorScheme = ColorScheme.fromSeed(
                seedColor: _brandPrimary,
              );

              darkColorScheme = ColorScheme.fromSeed(
                seedColor: _brandPrimary,
                brightness: Brightness.dark,
              );
            }

            return MaterialApp(
              title: 'RemindMe',
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                        color: lightColorScheme.onBackground, fontSize: 22),
                    backgroundColor: Colors.white.withAlpha(0),
                    centerTitle: true,
                    elevation: 0),
                floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: lightColorScheme.primaryContainer,
                    foregroundColor: lightColorScheme.onPrimaryContainer),
              ),
              darkTheme: ThemeData(
                colorScheme: darkColorScheme,
                appBarTheme: AppBarTheme(
                    titleTextStyle: TextStyle(
                        color: darkColorScheme.onBackground, fontSize: 22),
                    backgroundColor: Colors.white.withAlpha(0),
                    centerTitle: true,
                    elevation: 0),
              ),
              home: const HomePage(),
            );
          }),
        ));
  }
}
