import 'package:flutter/material.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/controllers/marchand_controller.dart';
import 'package:ussd_code_app/controllers/test_controller.dart';
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
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd_advanced/ussd_advanced.dart';

class modelmarchand extends StatefulWidget {
  //modelmarchand({Key? key}) : super(key: key);
  modelmarchand(this.libeler, this.idmarch);
  final String libeler;
  final int idmarch;

  @override
  State<modelmarchand> createState() => _modelmarchandState();
}

enum RequestState {
  ongoing,
  success,
  error,
  ongoing1,
  success1,
  error1,
}

class _modelmarchandState extends State<modelmarchand> {
  RequestState? _requestState;
  RequestState? _requestState1;
  String _requestCode = "";
  String _requestCodes = "";

  String _responseCode = "";
  String _responseCode1 = "";

  String _responseMessage = "";
  String? _responseMessages = "";
  TextEditingController libelercontroller = TextEditingController();
  var marchcontrollers = marchandcontroller(marchand_repository());

  Future opendialog(TextEditingController libelercontroller,
          marchandcontroller testcontrollers, int idmarchand) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Add new code Ussd"),
                content: Container(
                  height: MediaQuery.of(context).size.height / 10.8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: libelercontroller,
                        decoration:
                            InputDecoration(hintText: "Entrer le montant"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 55,
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text('PAYER'),
                    onPressed: () {
                      //  sendUssdRequestdf('*880*${41}*${idmarchand}*${libelercontroller.text}#', 0);
                      sendUssdRequestdf('*880#', 0);
                      // print(
                      //     '*880*${41}*${idmarchand}*${libelercontroller.text}#');
                      // abor(context,
                      //     '*880*${41}*${idmarchand}*${libelercontroller.text}#');
                      // postussdcode(
                      //     libelercontroller, usssdcontroller, testcontrollers);
                    },
                  )
                ],
              ));

  void submit() {
    Navigator.of(context).pop();
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

  Future<void> sendUssdRequestdf(String ussd, int sim) async {
    // setState(() {
    //   _requestState1 = RequestState.ongoing1;
    // });
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      String? _res =
          await UssdAdvanced.multisessionUssd(code: ussd, subscriptionId: 0);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 8.25,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        child: Card(
          // color: Color.fromARGB(255, 245, 246, 250).withOpacity(0),
          child: Container(
            color: Color.fromARGB(255, 236, 235, 235),
            //height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: (() {
                    opendialog(
                        libelercontroller, marchcontrollers, widget.idmarch);
                  }),
                  child: Text(widget.libeler),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
