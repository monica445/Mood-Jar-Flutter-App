// import 'package:flutter_test/flutter_test.dart';
// import 'package:mood_jar_app/domain/entities/mood_entry.dart';
// import 'package:mood_jar_app/domain/entities/mood_per_day.dart';
// import 'package:mood_jar_app/domain/enums/mood_type.dart';
// import 'package:mood_jar_app/data/repository/database_helper.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// void main() {
//   // Initialize sqflite ffi for tests
//   sqfliteFfiInit();
//   databaseFactory = databaseFactoryFfi;

//   // Set up the database before all tests
//   setUpAll(() async {
//     await DatabaseHelper.getDb();
//     await DatabaseHelper.printDbPath();
//     await DatabaseHelper.deleteAllData(); // start fresh
//   });

//   // Close database after all tests
//   tearDownAll(() async {
//     await DatabaseHelper.closeDb();
//   });

// group('seed data for MoodJar', () {
//   test("add mood per day", () async {
//     final moodPerDay = await DatabaseHelper.addMoodPerDayWithId(
//       MoodPerDay(date: DateTime(2025, 12, 30))
//     );

//     final fetchedMoodPerDay = await DatabaseHelper.getMoodPerDay(DateTime(2025, 12, 30));

//     expect(fetchedMoodPerDay, isNotNull);
//     expect(fetchedMoodPerDay!.date, DateTime(2025, 12, 30));
//   });

//   test("add mood entries", () async {
//     final day = await DatabaseHelper.getMoodPerDay(DateTime(2025, 12, 30));
//     expect(day, isNotNull);

//     await DatabaseHelper.addNewMood(MoodEntry(
//       type: Moodtype.great,
//       timestamp: DateTime(2025, 12, 30, 9, 0),
//       //note: "Morning walk",
//       moodPerDayId: day!.id!,
//     ));

//     await DatabaseHelper.addNewMood(MoodEntry(
//       type: Moodtype.neutral,
//       timestamp: DateTime(2025, 12, 30, 21, 0),
//       note: "Felt tired",
//       moodPerDayId: day.id!,
//     ));

//     final moods = await DatabaseHelper.getAllMoodEntry();
//     expect(moods.length, greaterThan(0));
//   });
// });

//   TestWidgetsFlutterBinding.ensureInitialized();

//   test('Fetch MoodPerDay with moods', () async {
//     final moodDays = await DatabaseHelper.getMoodPerDayWithMoods();
//     expect(moodDays, isNotEmpty); // checks that the list is not empty

//     for (var day in moodDays) {
//       print('Date: ${day.date}');
//       for (var mood in day.moods) {
//         print('  Mood: ${mood.type.name}, Note: ${mood.note}');
//       }
//     }
//   });


// }
