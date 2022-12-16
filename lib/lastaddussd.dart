import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/bodymarchand.dart';
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
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

late int garfe = 0;
late bool garf = true;

class lastaddussd extends StatefulWidget {
  final Database database;
  lastaddussd({Key? key, required this.database}) : super(key: key);

  @override
  State<lastaddussd> createState() => _lastaddussdState();
}

enum RequestState {
  ongoing,
  success,
  error,
  ongoing1,
  success1,
  error1,
}

class _lastaddussdState extends State<lastaddussd> {
  @override
  Widget build(BuildContext context) {
    var testcontrollers = testcontroller(test_repository(), widget.database);

    TextEditingController libelercontroller = TextEditingController();
    TextEditingController usssdcontroller = TextEditingController();

    Future loadlist() async {
      setState(() {
        testcontrollers.getlastlist();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
        title: const Text('Last Ussd code'),
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            'Last Ussd code',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              child: FutureBuilder<List<test>>(
                  future: testcontrollers.getlastlist(),
                  //  future: getprodlist(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: Text(
                              'veillez verifier votre connection internet'));
                    }
                    return
                        //builbodycontent(snapshot, produitcontrollers);
                        RefreshIndicator(
                            onRefresh: () {
                              loadlist();
                              throw UnimplementedError();
                            },
                            child: builbodycontent(snapshot, testcontrollers));
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
        onPressed: () {
          // opendialog(usssdcontroller, libelercontroller, marchcontrollers);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Details()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  SafeArea builbodycontent(
      AsyncSnapshot<List<test>> snapshot, testcontroller testcontrollers) {
    void loadlist() {
      setState(() {
        testcontrollers.gettestlist();
      });
    }

    return SafeArea(
      child: ListView.separated(
          itemBuilder: (context, index) {
            var test = snapshot.data?[index];
            return Container(
              height: MediaQuery.of(context).size.height / 8.25,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height / 51.56),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      flex: 3,
                      child: Text(
                        "${test?.libeler}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                  // Expanded(flex: 3, child: Text("${test?.prenom}")),
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                              onTap: () {
                                // add methode
                                sendUssdRequestdf(
                                    test!.codeussd, test.simchoice);
                                // loadlist();
                              },
                              child: buildcallcontainer(
                                  'request', Color(0xFFFFE0B2))),
                        ],
                      )),
                ],
              ),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              thickness: 0.5,
              height: 0.5,
            );
          },
          itemCount: snapshot.data?.length ?? 0),
    );
  }

  RequestState? _requestState;
  RequestState? _requestState1;
  String _requestCode = "";
  String _requestCodes = "";

  String _responseCode = "";
  String _responseCode1 = "";

  String _responseMessage = "";
  String? _responseMessages = "";

  Future<void> sendUssdRequestdf(String ussd, int sim) async {
    setState(() {
      _requestState1 = RequestState.ongoing1;
    });
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      String? _res =
          await UssdAdvanced.multisessionUssd(code: ussd, subscriptionId: sim);
      //  await UssdAdvanced.sendAdvancedUssd(
      //     code: _requestCodes, subscriptionId: 1);

      setState(() {
        _requestState1 = RequestState.success1;
        _responseMessages = _res;
      });
    } on PlatformException catch (e) {
      setState(() {
        _requestState1 = RequestState.error1;
        _responseCode1 = e is PlatformException ? e.code : "";
        _responseMessages = e.message ?? '';
      });
    }
  }

  void show_FlushbarHelper(BuildContext context, dynamic repe) {
    FlushbarHelper.createInformation(
        title: "Informations", message: repe.toString())
      ..show(context);
  }

  void abor(BuildContext context, dynamic repe) {
    Fluttertoast.showToast(
        msg: repe,
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
        // fontSize: 25
        // gravity: ToastGravity.TOP,
        textColor: Color.fromARGB(255, 230, 228, 228));
  }

  Container buildcallcontainer(String title, Color color) {
    return Container(
      width: MediaQuery.of(context).size.height / 11.78,
      height: MediaQuery.of(context).size.height / 20.63,
      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.height / 82.5),
      ),
      child: Center(
          child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height / 103.12),
        child: Text(
          '$title',
        ),
      )),
    );
  }
}
