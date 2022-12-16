import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/controllers/test_controller.dart';
import 'package:ussd_code_app/controllers/ussd_controller.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';
import 'package:ussd_code_app/repository/ussd_repository.dart';

Future<void> init() async {
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
  //api client
  // Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL));
  // repository
  // Get.lazyPut(() => ussdReposi(database: database));

  //controllers
  // Get.lazyPut(() => ussdcontroller(database: database, ussdRepo: Get.find()));
}
