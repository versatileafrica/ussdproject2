import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ussdcode extends StatefulWidget {
  ussdcode({Key? key}) : super(key: key);

  @override
  State<ussdcode> createState() => _ussdcodeState();
}

enum RequestState {
  ongoing,
  success,
  error,
  ongoing1,
  success1,
  error1,
}

class _ussdcodeState extends State<ussdcode> {
  RequestState? _requestState;
  RequestState? _requestState1;
  String _requestCode = "";
  String _requestCodes = "";

  String _responseCode = "";
  String _responseCode1 = "";

  String _responseMessage = "";
  String? _responseMessages = "";
  Future<void> sendUssdRequest() async {
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
      responseMessage = await UssdService.makeRequest(
          simData.cards.first.subscriptionId, _requestCode);
      setState(() {
        _requestState = RequestState.success;
        _responseMessage = responseMessage;
      });
    } on PlatformException catch (e) {
      setState(() {
        _requestState = RequestState.error;
        _responseCode = e is PlatformException ? e.code : "";
        _responseMessage = e.message ?? '';
      });
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

  void abor(BuildContext context, dynamic repe) {
    Fluttertoast.showToast(
        msg: repe,
        backgroundColor: Color.fromARGB(255, 46, 46, 46),
        // fontSize: 25
        // gravity: ToastGravity.TOP,
        textColor: Color.fromARGB(255, 230, 228, 228));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter Code',
              ),
              onChanged: (newValue) {
                setState(() {
                  _requestCode = newValue;
                });
              },
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _requestState == RequestState.ongoing
                  ? null
                  : () {
                      sendUssdRequest();
                    },
              child: const Text('Send Ussd request'),
            ),
            const SizedBox(height: 20),
            if (_requestState == RequestState.ongoing)
              Row(
                children: const <Widget>[
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 24),
                  Text('Ongoing request...'),
                ],
              ),
            if (_requestState == RequestState.success) ...[
              const Text('Last request was successful.'),
              const SizedBox(height: 10),
              const Text('Response was:'),
              Text(
                _responseMessage,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            if (_requestState == RequestState.error) ...[
              //   const Text('Last request was not successful'),
              //   const SizedBox(height: 10),
              //   const Text('Error code was:'),
              //   Text(
              //     _responseCode,
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
              //   const SizedBox(height: 10),
              //   const Text('Error message was:'),
              //   Text(
              //     _responseMessage,
              //     style: const TextStyle(fontWeight: FontWeight.bold),
              //   ),
            ],
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Enter multi step Code',
              ),
              onChanged: (newValuer) {
                setState(() {
                  _requestCodes = newValuer;
                });
              },
            ),
            const SizedBox(height: 20),
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: _requestState == RequestState.ongoing1
                  ? null
                  : () {
                      sendUssdRequestdf();
                    },
              child: const Text('Send single session request'),
            ),
            const SizedBox(height: 20),
            // if (_requestState1 == RequestState.ongoing1)
            //   Row(
            //     children: const <Widget>[
            //       SizedBox(
            //         width: 24,
            //         height: 24,
            //         child: CircularProgressIndicator(),
            //       ),
            //       SizedBox(width: 24),
            //       Text('Ongoing request...'),
            //     ],
            //   ),
            // if (_requestState1 == RequestState.success1) ...[
            //   const Text('Last request was successful.'),
            //   const SizedBox(height: 10),
            //   const Text('Response was:'),
            //   Text(
            //     _responseMessages.toString(),
            //     style: const TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ],
            // if (_requestState1 == RequestState.error1) ...[
            //   const Text('Last request was not successful'),
            //   const SizedBox(height: 10),
            //   const Text('Error code was:'),
            //   Text(
            //     _responseCode,
            //     style: const TextStyle(fontWeight: FontWeight.bold),
            //   ),
            //   const SizedBox(height: 10),
            //   const Text('Error message was:'),
            //   Text(
            //     _responseMessages.toString(),
            //     style: const TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ]
          ]),
    );
  }
}
