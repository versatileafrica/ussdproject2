import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ussd_code_app/controllers/test_controller.dart';
import 'package:ussd_code_app/controllers/ussd_controller.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';
import 'package:ussd_code_app/repository/test/test_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sim_data/sim_data.dart';
import 'package:ussd_service/ussd_service.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:cron/cron.dart';
// import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

late int garfe;

class sim1 extends StatefulWidget {
  final Database database;
  sim1({Key? key, required this.database}) : super(key: key);

  @override
  State<sim1> createState() => _sim1State();
}

enum RequestState {
  ongoing,
  success,
  error,
  ongoing1,
  success1,
  error1,
}

class _sim1State extends State<sim1> {
  RequestState? _requestState;
  RequestState? _requestState1;
  List<test>? ussd;
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
        print(responseMessage);
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

      // await UssdAdvanced.sendUssd(code: ussd, subscriptionId: sim);
      print(ussd + "ussd code");
      // String? _rese =
      //     await UssdAdvanced.sendAdvancedUssd(code: ussd, subscriptionId: 1);
      String? _res =
          await UssdAdvanced.multisessionUssd(code: ussd, subscriptionId: 1);
      //  await UssdAdvanced.sendAdvancedUssd(
      //     code: _requestCodes, subscriptionId: 1);

      setState(() {
        _requestState1 = RequestState.success1;
        // _responseMessages = _res;
        print(ussd);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshnote();
  }

  Future refreshnote() async {
    // var testcontrollers = ussdcontroller(database: widget.database);
    //testcontrollers.readallnote();
    // this.ussd = await testcontrollers.readallnote();
  }

  @override
  Widget build(BuildContext context) {
    // dependency injection
    var testcontrollers = testcontroller(test_repository(), widget.database);

    TextEditingController libelercontroller = TextEditingController();
    TextEditingController usssdcontroller = TextEditingController();

    Future loadlist() async {
      setState(() {
        testcontrollers.gettestlist();
      });
    }

    Future loadlist1() async {
      setState(() {
        testcontrollers.initialise();
      });
    }

    @override
    void initState() {
      print("taille " + MediaQuery.of(context).size.height.toString());
      print("taille " + MediaQuery.of(context).size.width.toString());
      super.initState();
    }

    return Scaffold(
        backgroundColor: Color.fromARGB(249, 232, 233, 235),
        // appBar: AppBar(
        //   title: Text('REST API'),
        //   backgroundColor: Colors.orange[100],
        // ),
        body: builbodycontent(
            ussd, testcontrollers, usssdcontroller, libelercontroller));
    // FutureBuilder<List<test>>(
    //     // future: testcontrollers.gettestlist(),
    //     future: testcontrollers.initialise(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return Center(
    //           child: CircularProgressIndicator(),
    //         );
    //       }
    //       if (snapshot.hasError) {
    //         return Center(
    //             child: Text('veillez verifier votre connection internet'));
    //       }
    //       return RefreshIndicator(
    //           onRefresh: () {
    //             loadlist1();
    //             throw UnimplementedError();
    //           },
    //           child: builbodycontent(snapshot, testcontrollers,
    //               usssdcontroller, libelercontroller));
    //     }),
    // floatingActionButton: FloatingActionButton(
    //   onPressed: () {
    //     postussdcode();
    //     loadlist();
    //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     //     duration: const Duration(milliseconds: 1000),
    //     //     content: Text('inserer')));
    //   },
    //   child: Icon(Icons.add),
    // ),
    // );
  }

  final cron = Cron();

  repeate() {
    cron.schedule(Schedule.parse('*/1 * * * *'), () async {
      print('every one minutes');
    });
  }

  void show_FlushbarHelper(BuildContext context, dynamic repe) {
    FlushbarHelper.createInformation(
        title: "Informations",
        message: repe.toString(),
        duration: Duration(seconds: 10))
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

  void postussdcode() async {
    var resp = await http.post(
      Uri.parse('https://backend-shop.benindigital.com/addussd'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"libeler": "*104*3#", "codeussd": "*104*3#"}),
    );
    print(resp.statusCode);
    print(resp.body);
    show_FlushbarHelper(context, resp.body);
  }

  SafeArea builbodycontent(
      // AsyncSnapshot<List<test>> snapshot,
      List<test>? snapshot,
      testcontroller testcontrollers,
      TextEditingController libelercontroller,
      TextEditingController usssdcontroller) {
    void loadlist() {
      setState(() {
        testcontrollers.gettestlist();
      });
    }

    return SafeArea(child: GetBuilder<ussdcontroller>(
        // init: Get.put(ussdcontroller(database: widget.database)),
        builder: (controlleeer) {
      List<test> list = controlleeer.ussdlist;
      if (kDebugMode) {
        print(list.length.toString() + "ftet");
      }
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return list.isNotEmpty
                ? Container(
                    color: Colors.red,
                    width: double.maxFinite,
                    height: 500,
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.height / 51.56),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 1,
                            child: Text(
                              "${list[index].libeler}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            )),
                        // Expanded(flex: 3, child: Text("${test?.prenom}")),
                        Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                InkWell(
                                    onTap: () {
                                      // add methode
                                      sendUssdRequestdf(list[index].codeussd,
                                          list[index].simchoice);
                                      // loadlist();
                                    },
                                    child: buildcallcontainer(
                                        'request', Color(0xFFFFE0B2))),
                                InkWell(
                                    onTap: () {
                                      // add methode
                                      // opendialog(usssdcontroller, libelercontroller,
                                      //     testcontrollers, test!.libeler, test.codeussd);
                                      // setState(() {
                                      //   garfe = test.simchoice;
                                      // });
                                      print("taille " +
                                          MediaQuery.of(context)
                                              .size
                                              .height
                                              .toString());
                                      print("taille " +
                                          MediaQuery.of(context)
                                              .size
                                              .width
                                              .toString());
                                      // abor(context, 'update en cours ');
                                      repeate();
                                    },
                                    child: buildcallcontainer(
                                        'update', Color(0xFFE1BEE7))),
                                InkWell(
                                    onTap: () {
                                      // add methode
                                      // deleteussdcode(test!.id, testcontrollers);
                                      deleteussdcode(
                                          list[index].id, testcontrollers);
                                      loadlist();
                                    },
                                    child: buildcallcontainer(
                                        'delete', Color(0xFFFFCDD2))),
                              ],
                            )),
                      ],
                    ),
                  )
                : CircularProgressIndicator();
          });
    }

        // ListView.separated(
        //     itemBuilder: (context, index) {
        //       // var test = snapshot.data?[index];
        //       var test = snapshot?[index];
        //       return Container(
        //         height: MediaQuery.of(context).size.height / 8.25,
        //         padding: EdgeInsets.symmetric(
        //             horizontal: MediaQuery.of(context).size.height / 51.56),
        //         child: Row(
        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //           children: [
        //             Expanded(
        //                 flex: 1,
        //                 child: Text(
        //                   "${test?.libeler}",
        //                   style: TextStyle(fontWeight: FontWeight.bold),
        //                 )),
        //             // Expanded(flex: 3, child: Text("${test?.prenom}")),
        //             Expanded(
        //                 flex: 3,
        //                 child: Row(
        //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                   children: [
        //                     InkWell(
        //                         onTap: () {
        //                           // add methode
        //                           sendUssdRequestdf(
        //                               test!.codeussd, test.simchoice);
        //                           // loadlist();
        //                         },
        //                         child: buildcallcontainer(
        //                             'request', Color(0xFFFFE0B2))),
        //                     InkWell(
        //                         onTap: () {
        //                           // add methode
        //                           // opendialog(usssdcontroller, libelercontroller,
        //                           //     testcontrollers, test!.libeler, test.codeussd);
        //                           // setState(() {
        //                           //   garfe = test.simchoice;
        //                           // });
        //                           print("taille " +
        //                               MediaQuery.of(context)
        //                                   .size
        //                                   .height
        //                                   .toString());
        //                           print("taille " +
        //                               MediaQuery.of(context)
        //                                   .size
        //                                   .width
        //                                   .toString());
        //                           // abor(context, 'update en cours ');
        //                           repeate();
        //                         },
        //                         child: buildcallcontainer(
        //                             'update', Color(0xFFE1BEE7))),
        //                     InkWell(
        //                         onTap: () {
        //                           // add methode
        //                           // deleteussdcode(test!.id, testcontrollers);
        //                           deleteussdcode(test!.id, testcontrollers);
        //                           loadlist();
        //                         },
        //                         child: buildcallcontainer(
        //                             'delete', Color(0xFFFFCDD2))),
        //                   ],
        //                 )),
        //           ],
        //         ),
        //       );
        //     },
        //     separatorBuilder: (context, index) {
        //       return Divider(
        //         thickness: 0.5,
        //         height: 0.5,
        //       );
        //     },
        //     // itemCount: snapshot.data?.length ?? 0),
        //     itemCount: snapshot?.length ?? 0),
        ));
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

  void deleteussdcode(int id, testcontroller testcontrollers) async {
    var resp = await http.delete(
      Uri.parse('https://backend-shop.benindigital.com/delussd'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"id": id}),
    );
    print(resp.statusCode);
    print(resp.body);
    setState(() {
      testcontrollers.gettestlist();
    });
    show_FlushbarHelper(context, resp.body);
  }

  void deleteussdcode1(int id, testcontroller testcontrollers) async {
    final db = await widget.database;
    await db.delete(
      'ussd',
      // Use a `where` clause to delete a specific dog.
      // where: 'id = ? & name = ?',
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      // whereArgs: [id,name],
      whereArgs: [id],
    );
    setState(() {
      testcontrollers.gettestlist();
    });
    show_FlushbarHelper(context, "delete succefully");
  }

  Future opendialog(
          TextEditingController libelercontroller,
          TextEditingController usssdcontroller,
          testcontroller testcontrollers,
          String libeler,
          String ussdcode) =>
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Add new code Ussd"),
                content: Container(
                  height: MediaQuery.of(context).size.height / 5.8,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: libelercontroller,
                        decoration: InputDecoration(hintText: libeler),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: usssdcontroller,
                        decoration: InputDecoration(hintText: ussdcode),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Envoyer'),
                    onPressed: () {
                      // updateussdcode(
                      //     libelercontroller, usssdcontroller, testcontrollers);
                    },
                  )
                ],
              ));

  void updateussdcode(
      TextEditingController libelercontroller,
      TextEditingController usssdcontroller,
      testcontroller testcontrollers) async {
    print(libelercontroller.text);
    print(usssdcontroller.text);
    print(garfe);
    var resp = await http.put(
      Uri.parse('https://backend-shop.benindigital.com/updateussd'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "libeler": libelercontroller.text,
        "codeussd": usssdcontroller.text,
        "simchoice": garfe
      }),
    );
    print(resp.statusCode);
    print(resp.body);
    submit();
    libelercontroller.clear();
    usssdcontroller.clear();
    setState(() {
      testcontrollers.gettestlist();
    });
    show_FlushbarHelper(context, resp.body);
  }

  void submit() {
    Navigator.of(context).pop();
  }
}
