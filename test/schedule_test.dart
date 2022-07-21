import 'package:flutter_test/flutter_test.dart';
import 'package:remind_me/data/models/schedule.dart';

void main() {
  group("Schedule logic >", () {
    test("Not all time fields can be null", () {
      expect(() => Schedule(repeating: false), throwsAssertionError);
    });
    test("Minute must be between 0-59", () {
      for (int i = -1; i < 61; i++) {
        if (i < 0 || i > 59) {
          expect(() => Schedule(repeating: false, minute: i),
              throwsAssertionError);
        }
      }
    });
    test("Hour must be between 0-23", () {
      for (int i = -1; i < 25; i++) {
        if (i < 0 || i > 23) {
          expect(
              () => Schedule(repeating: false, hour: i), throwsAssertionError);
        }
      }
    });

    test("Day must be between 1-31", () {
      for (int i = -1; i < 61; i++) {
        if (i < 1 || i > 31) {
          expect(
              () => Schedule(repeating: false, day: i), throwsAssertionError);
        }
      }
    });

    test("Weekday must be between ${DateTime.monday}-${DateTime.sunday}", () {
      for (int i = -1; i < 61; i++) {
        if (i < DateTime.monday || i > DateTime.sunday) {
          expect(() => Schedule(repeating: false, weekday: i),
              throwsAssertionError);
        }
      }
    });

    test("Month must be between ${DateTime.january}-${DateTime.december}", () {
      for (int i = -1; i < 61; i++) {
        if (i < DateTime.january || i > DateTime.december) {
          expect(
              () => Schedule(repeating: false, month: i), throwsAssertionError);
        }
      }
    });

    test("If not repeating, must provide full date fields", () {
      expect(() => Schedule(repeating: false), throwsAssertionError);
      expect(() => Schedule(repeating: false, minute: 0), throwsAssertionError);
      expect(() => Schedule(repeating: false, minute: 0, hour: 0),
          throwsAssertionError);
      expect(() => Schedule(repeating: false, minute: 0, day: 1),
          throwsAssertionError);
      expect(() => Schedule(repeating: false, minute: 0, month: 2),
          throwsAssertionError);
      expect(() => Schedule(repeating: false, minute: 0, year: 2017),
          throwsAssertionError);
    });

    test("If repeating daily, must provide time", () {
      expect(() => Schedule(repeating: true), throwsAssertionError);
      expect(() => Schedule(repeating: true, minute: 0), throwsAssertionError);
      expect(() => Schedule(repeating: true, hour: 0), throwsAssertionError);
    });

    test("If repeating weekly, must provide weekday and time", () {
      expect(() => Schedule(repeating: true, weekday: 1), throwsAssertionError);
      expect(() => Schedule(repeating: true, weekday: 1, minute: 0),
          throwsAssertionError);
      expect(() => Schedule(repeating: true, weekday: 1, hour: 0),
          throwsAssertionError);
    });

    test("If repeating monthly, must provide day time", () {
      expect(() => Schedule(repeating: true, day: 1), throwsAssertionError);
      expect(() => Schedule(repeating: true, day: 1, minute: 0),
          throwsAssertionError);
      expect(() => Schedule(repeating: true, day: 1, hour: 0),
          throwsAssertionError);
    });
  });
  // group("Schedule Parsing >", () {
  //   test('Minutes less than 10 give a zero before clock time in the string',
  //       () {
  //     Schedule schedule = Schedule(repeating: false, hour: 22, minute: 5);
  //     expect(schedule.toString(), contains("05"));
  //   });
  // });
}
