import 'package:ussd_code_app/models/marchand.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/marchand/repository_marchand.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';

class marchandcontroller {
  final Repositorymarchand _repository;

  marchandcontroller(this._repository);

  Future<List<marchand>> gettestlist() async {
    return _repository.gettestlist();
  }

  Future<List<marchand>> gettestlist1() async {
    return _repository.gettestlist1();
  }

  Future<String> puttest(marchand rest) async {
    return _repository.puttest(rest);
  }

  Future<String> deletetest(marchand rest) async {
    return _repository.deletetest(rest);
  }

  Future<String> posttest(marchand rest) async {
    return _repository.posttest(rest);
  }
}
