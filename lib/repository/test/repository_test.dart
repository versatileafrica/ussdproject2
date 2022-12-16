import 'package:get/get.dart';
import 'package:ussd_code_app/models/test.dart';

abstract class Repositorytest {
  //get
  Future<List<test>> gettestlist();

  Future<List<test>> gettestlist1();

  Future<List<test>> getlastlist();
  //put
  Future<String> puttest(test rest);
  //delete
  Future<String> deletetest(test rest);
  //post
  Future<String> posttest(test rest);
}
