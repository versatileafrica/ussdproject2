import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/ussd_repository.dart';

class ussdcontroller extends GetxController {
  // final ussdReposi ussdRepo;
  // final Database database;
  // ussdcontroller({required this.database});
  List<test> _ussdlist = [];
  List<test> get ussdlist => _ussdlist;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  Future<void> initialise(Database db) async {
    //final db = await database;
    List<test> testlist = [];
    final List<Map<String, dynamic>> maps = await db.query('ussd');
    //  var body = jsonDecode(maps);
    print(maps);
    for (var i = 0; i < maps.length; i++) {
      testlist.add(test.fromJson(maps[i]));
    }
    _ussdlist = [];
    _ussdlist = maps.map((e) => test.fromJsonn(e)).toList();
    _isLoaded = true;
    update();
    // testlist = maps.map((e) => test()).toString();
    print(testlist);
    print(_ussdlist);

    // return testlist;
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    // return List.generate(maps.length, (i) {
    //   return test(
    //     id: maps[i]['id'],
    //     name: maps[i]['name'],
    //     age: maps[i]['age'],
    //   );
    // });
  }
//  Future<test> postussdcode1(test ussd) async {
//     final db = await database;

//     final id = await db.insert(
//       "ussd",
//       ussd.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//     submit();
//     show_FlushbarHelper(context, "resp.body");
//     return ussd.copy(id: id);
//   }
  Future<test> readnote(int id, Database db) async {
    //final db = await database;
    final maps = await db.query('ussd',
        columns: testFields.values,
        where: '${testFields.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      update();
      return test.fromJsonn(maps.first);
    } else {
      update();
      throw Exception('Id $id not found');
    }
  }

  Future<void> postussdcode1(test ussd, List<test> data, Database datas) async {
    final db = await datas;

    final id = await db.insert(
      "ussd",
      ussd.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    //  _ussdlist.add(...data,ussd.toJson());
    print("babba");
    // show_FlushbarHelper(context, "resp.body");
    //return ussd.copy(id: id);
  }

  Future<void> readallnote(Database data) async {
    final db = await data;
    final orderBy = '${testFields.id} ASC';
    // final sql = 'SELECT * FROM ussd ORDER BY $orderBy';
    final sql = 'SELECT * FROM ussd';
    final result = await db.rawQuery(sql);
    // final result = await db.query('ussd', orderBy: orderBy);
    if (result.isNotEmpty) {
      print("dans le if $result");
      _ussdlist = [];
      _ussdlist = result.map((e) => test.fromJsonn(e)).toList();
      _isLoaded = true;
    } else {
      print("Erreur de $result");
    }
    update();
    // return result.map((e) => test.fromJsonn(e)).toList();
  }

  Future<int> updatee(test tesr, Database db) async {
    //final db = await database;
    update();
    return db.update('ussd', tesr.toJson(),
        where: '${testFields.id} = ?', whereArgs: [tesr.id]);
  }

  Future<int> delete(int id, Database db) async {
    //final db = await database;
    update();
    return await db
        .delete('ussd', where: '${testFields.id} = ?', whereArgs: [id]);
  }

  Future close(Database db) async {
    //final db = await database;
    db.close();
    update();
  }
}
