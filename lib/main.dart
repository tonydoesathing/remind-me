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
                  colorScheme: lightColorScheme,
                  appBarTheme: AppBarTheme(
                      titleTextStyle: TextStyle(
                          color: lightColorScheme.onBackground, fontSize: 22),
                      backgroundColor: Colors.white.withAlpha(0),
                      centerTitle: true,
                      elevation: 0),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                      backgroundColor: lightColorScheme.primaryContainer,
                      foregroundColor: lightColorScheme.onPrimaryContainer)),
              darkTheme: ThemeData(
                  colorScheme: darkColorScheme,
                  appBarTheme: AppBarTheme(
                      titleTextStyle: TextStyle(
                          color: darkColorScheme.onBackground, fontSize: 22),
                      backgroundColor: Colors.white.withAlpha(0),
                      centerTitle: true,
                      elevation: 0)),
              home: const HomePage(),
            );
          }),
        ));
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: ((context) =>
          HomeBloc(context.read<ReminderRepository>())..add(LoadHomeEvent())),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return Center(
              child: Text("Meow"),
            );
          } else if (state is HomeLoaded) {
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
                  context.read<HomeBloc>().add(const AddNewReminder(null));
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
                          EditReminder(state.reminders[index]
                              .copyWith(enabled: result))),
                    );
                  })),
            );
          } else {
            return Center(
              child: Text("nothing "),
            );
          }
        },
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: ((context) => TestBlocBloc()..add(const AddCounter(0))),
//       child: BlocBuilder<TestBlocBloc, TestBlocState>(
//         builder: (context, state) {
//           if (state is TestBlocInitial) {
//             return Center(
//               child: Text("Initial"),
//             );
//           } else if (state is TestBlocLoaded) {
//             return Scaffold(
//               appBar: AppBar(title: const Text("RemindMe")),
//               floatingActionButton: FloatingActionButton(onPressed: (() {
//                 context.read<TestBlocBloc>().add(AddCounter(state.counter));
//               })),
//               body: Center(
//                   child: Column(
//                 children: [Text(state.counter.toString())],
//               )),
//             );
//           } else {
//             return Center(
//               child: Text("nothing "),
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key, required this.title}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
