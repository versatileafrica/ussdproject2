import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';
import 'package:get/get.dart';

class testcontroller extends GetxController {
  final Repositorytest _repository;
  final Database database;
  List<test> _ussdlist = [];
  List<test> get ussdlist => _ussdlist;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;
  testcontroller(this._repository, this.database);

  Future<List<test>> gettestlist() async {
    return _repository.gettestlist();
  }

  Future<List<test>> gettestlist1() async {
    return _repository.gettestlist1();
  }

  Future<List<test>> getlastlist() async {
    return _repository.getlastlist();
  }

  Future<String> puttest(test rest) async {
    return _repository.puttest(rest);
  }

  Future<String> deletetest(test rest) async {
    return _repository.deletetest(rest);
  }

  Future<String> posttest(test rest) async {
    return _repository.posttest(rest);
  }

  Future<void> initialise() async {
    final db = await database;
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

  Future<test> readnote(int id) async {
    final db = await database;
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

  Future<void> readallnote() async {
    final db = await database;
    final orderBy = '${testFields.id} ASC';
    // final sql = 'SELECT * FROM ussd ORDER BY $orderBy';
    // final ref = await db.rawQuery(sql);
    final result = await db.query('ussd', orderBy: orderBy);
    _ussdlist = [];
    _ussdlist = result.map((e) => test.fromJsonn(e)).toList();
    _isLoaded = true;
    update();
    // return result.map((e) => test.fromJsonn(e)).toList();
  }

  Future<int> updatee(test tesr) async {
    final db = await database;
    update();
    return db.update('ussd', tesr.toJson(),
        where: '${testFields.id} = ?', whereArgs: [tesr.id]);
  }

  Future<int> delete(int id) async {
    final db = await database;
    update();
    return await db
        .delete('ussd', where: '${testFields.id} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await database;
    db.close();
    update();
  }
}
