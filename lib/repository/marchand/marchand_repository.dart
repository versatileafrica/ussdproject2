import 'package:ussd_code_app/models/marchand.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/marchand/repository_marchand.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class marchand_repository implements Repositorymarchand {
  String dataurl = 'https://backend-shop.benindigital.com/api';
//  String dataurl = 'http://localhost:3004/api';
  @override
  Future<String> deletetest(marchand march) async {
    // todo implement deletetodo
    throw UnimplementedError();
  }

  @override
  Future<List<marchand>> gettestlist() async {
    // todo implement gettodolist
    //throw UnimplementedError();
    List<marchand> testlist = [];
    var url = Uri.parse('$dataurl/readingmarch');
    var response = await http.get(url);
    print('status code : ${response.statusCode}');
    var body = jsonDecode(response.body); // convertion de la donnee en json
    // parse
    for (var i = 0; i < body.length; i++) {
      testlist.add(marchand.fromJson(body[i]));
    }
    return testlist;
  }

  @override
  Future<List<marchand>> gettestlist1() async {
    // // todo implement gettodolist
    throw UnimplementedError();
    // List<marchand> testlist = [];
    // var url = Uri.parse('$dataurl/readingsim2');
    // var response = await http.get(url);
    // print('status code : ${response.statusCode}');
    // var body = jsonDecode(response.body); // convertion de la donnee en json
    // // parse
    // for (var i = 0; i < body.length; i++) {
    //   testlist.add(marchand.fromJson(body[i]));
    // }
    // return testlist;
  }

  @override
  Future<String> puttest(marchand rest) async {
    // todo implement putCompleted
    throw UnimplementedError();
    // var url = Uri.parse('$dataurl/update/:id');
    // // call back data
    // String resdata = '';
    // await http.put(
    //   url,
    //   body: {
    //     // 'completed': ('jaja'),
    //   },
    //   headers: {'Authorization': 'your_token'},
    // ).then((response) {
    //   // home screen data
    //   Map<String, dynamic> result = json.decode(response.body);
    //   print(result);
    //   return resdata = result['completed'];
    // });
    // return resdata;
  }

  @override
  Future<String> posttest(marchand rest) async {
    // todo implement posttodo
    throw UnimplementedError();
    //   print('${rest.toJson()}');
    //   var url = Uri.parse('$dataurl/create');
    //   var result = '';
    //   var response = await http.post(url, body: rest.toJson());
    //   print(response.statusCode);
    //   print(response.body);
    //   return 'true';
  }
}
