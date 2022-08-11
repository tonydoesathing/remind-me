import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

/// A provider for the Sembast-based database
class SembastProvider {
  /// setup singletons
  static final SembastProvider _provider = SembastProvider._();
  SembastProvider._();
  factory SembastProvider() => _provider;

  Database? _database;

  /// returns the app's Sembast-based database
  Future<Database> get database async {
    if (_database == null) {
      const String name = "remind_me.db";
      final Database db;
      // if we're on web, use a different loader
      if (kIsWeb) {
        db = await databaseFactoryWeb.openDatabase(name);
      } else {
        final directory = await getApplicationDocumentsDirectory();
        final path = join(directory.path, name);
        db = await databaseFactoryIo.openDatabase(path);
      }
      return db;
    } else {
      return _database!;
    }
  }
}
