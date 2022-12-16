import 'package:ussd_code_app/models/marchand.dart';
import 'package:ussd_code_app/models/test.dart';

abstract class Repositorymarchand {
  //get
  Future<List<marchand>> gettestlist();

  Future<List<marchand>> gettestlist1();
  //put
  Future<String> puttest(marchand rest);
  //delete
  Future<String> deletetest(marchand rest);
  //post
  Future<String> posttest(marchand rest);
}
