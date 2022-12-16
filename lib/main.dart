//import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/AppBarreDesign.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/homescreen.dart';
import 'package:ussd_code_app/ussdcode.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final Database database = await openDatabase(
    join(await getDatabasesPath(), 'ussd_database'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE ussd(id INTEGER PRIMARY KEY, libeler TEXT, codeussd TEXT, simchoice INTEGER)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  runApp(MyApp(database: database));
}

class MyApp extends StatefulWidget {
  final Database database;
  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          // appBar:  appbarmode(),
          body: appbarmode(database: widget.database)
          //ussdcode()
          ),
    );
  }
}
