import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cron/cron.dart';

class Detail extends StatefulWidget {
  Detail({Key? key}) : super(key: key);

  @override
  State<Detail> createState() => _DetailState();
}

enum RequestState {
  ongoing,
  success,
  error,
  ongoing1,
  success1,
  error1,
}

class _DetailState extends State<Detail> {
  RequestState? _requestState;
  RequestState? _requestState1;
  String _requestCode = "";
  String _requestCodes = "";

  String _responseCode = "";
  String _responseCode1 = "";

  String _responseMessage = "";
  String? _responseMessages = "";

  Future<void> sendUssdRequest(
      BuildContext context, String ussd, int sim) async {
    setState(() {
      _requestState = RequestState.ongoing;
    });
    try {
      String responseMessage;
      await Permission.phone.request();
      if (!await Permission.phone.isGranted) {
        throw Exception("permission missing");
      }

      SimData simData = await SimDataPlugin.getSimData();
      responseMessage = await UssdService.makeRequest(sim, ussd);
      setState(() {
        _requestState = RequestState.success;
        _responseMessage = responseMessage;
      });
      show_FlushbarHelper(context, responseMessage);
    } on PlatformException catch (e) {
      setState(() {
        _requestState = RequestState.error;
        _responseCode = e is PlatformException ? e.code : "";
        _responseMessage = e.message ?? '';
      });
      show_FlushbarHelper(context, e.message);
    }
  }

  Future<void> sendUssdRequestdf() async {
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
      String? _res = await UssdAdvanced.multisessionUssd(
          code: _requestCodes, subscriptionId: 0);
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
      title: "Informations",
      message: repe.toString(),
      duration: Duration(seconds: 10),
    )..show(context);
  }

  void abor(BuildContext context, dynamic repe) {
    Fluttertoast.showToast(
        msg: repe,
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
        // fontSize: 25
        // gravity: ToastGravity.TOP,
        //timeInSecForIosWeb: 20,
        textColor: Color.fromARGB(255, 230, 228, 228));
  }

  // void abore(BuildContext context, dynamic repe) {
  //   FlutterToastAlert.showToastAndAlert(
  //       type: Type.Normal,
  //       iosTitle: "Normal",
  //       iosSubtitle: repe,
  //       androidToast: repe,
  //       toastDuration: 3,
  //       toastShowIcon: true);
  // }

  final cron = Cron();

  repeate(BuildContext context) {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      // print('every one minutes');
      sendUssdRequest(context, "*104#", 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigator.pop(context);
            // sendUssdRequest(context, "*104#", 0);
            sendUssdRequest(context, "*104#", 0);
            repeate(context);
          },
          child: const Text('Cron request test automaticaly'),
        ),
      ),
    );
  }
}
