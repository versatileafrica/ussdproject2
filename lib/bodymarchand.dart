import 'package:flutter/material.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/controllers/marchand_controller.dart';
import 'package:ussd_code_app/controllers/test_controller.dart';
import 'package:ussd_code_app/modelmarchand.dart';
import 'package:ussd_code_app/models/marchand.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/marchand/marchand_repository.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';
import 'package:ussd_code_app/repository/test/test_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ussd_code_app/sim1.dart';
import 'package:ussd_code_app/sim2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cron/cron.dart';

class bodymarchandadd extends StatefulWidget {
  bodymarchandadd({Key? key}) : super(key: key);

  @override
  State<bodymarchandadd> createState() => _bodymarchandaddState();
}

class _bodymarchandaddState extends State<bodymarchandadd> {
  @override
  Widget build(BuildContext context) {
    //var testcontrollers = testcontroller(test_repository());
    var marchcontrollers = marchandcontroller(marchand_repository());

    Future loadlist() async {
      setState(() {
        marchcontrollers.gettestlist();
      });
    }

    return Column(
      // crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
          'Listes Des Marchands',
          style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        ),
        SizedBox(
          height: 50,
        ),
        Center(
          child: Container(
            height: 250,
            child: FutureBuilder<List<marchand>>(
                future: marchcontrollers.gettestlist(),
                //  future: getprodlist(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                        child:
                            Text('veillez verifier votre connection internet'));
                  }
                  return
                      //builbodycontent(snapshot, produitcontrollers);
                      RefreshIndicator(
                          onRefresh: () {
                            loadlist();
                            throw UnimplementedError();
                          },
                          child: builbodycontent(snapshot, marchcontrollers));
                }),
          ),
        ),
      ],
    );
  }

  SafeArea builbodycontent(AsyncSnapshot<List<marchand>> snapshot,
      marchandcontroller testcontrollers) {
    void loadlist() {
      setState(() {
        testcontrollers.gettestlist();
      });
    }

    return SafeArea(
      child: Container(
        height: 100,
        child: ListView.separated(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              var produ = snapshot.data?[index];
              // print(produ?.libeler);
              return modelmarchand(produ!.nom_marchand, produ.id_marchand);
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 1);
            },
            itemCount: snapshot.data?.length ?? 0),
      ),
    );
  }
}
