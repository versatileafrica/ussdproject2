import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/controllers/test_controller.dart';
import 'package:ussd_code_app/controllers/ussd_controller.dart';
import 'package:ussd_code_app/models/test.dart';
import 'package:ussd_code_app/repository/test/repository_test.dart';
import 'package:ussd_code_app/repository/test/test_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:another_flushbar/flushbar_helper.dart';
import 'package:ussd_code_app/sim1.dart';
import 'package:ussd_code_app/sim2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cron/cron.dart';
import 'package:ussd_code_app/test.dart';

late int garfe = 0;

class homescreen extends StatefulWidget {
  final Database database;
  homescreen({Key? key, required this.database}) : super(key: key);

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen>
    with SingleTickerProviderStateMixin {
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

    TabController? tabControler;

    @override
    void initState() {
      tabControler = TabController(length: 2, vsync: this);
      super.initState();
    }

    @override
    void dispose() {
      tabControler?.dispose();
      super.dispose();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromARGB(249, 232, 233, 235),
        // appBar: AppBar(
        //   title: Text('REST API'),
        //   backgroundColor: Colors.orange[100],
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  //height: 50,
                  width: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 84, 194, 221),
                      borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: TabBar(
                            onTap: (value) {
                              print(value + 1);
                              setState(() {
                                garfe = value + 1;
                              });
                            },
                            unselectedLabelColor: Colors.white,
                            indicatorColor: Colors.white,
                            indicatorWeight: 2,
                            indicator: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5)),
                            labelColor: Colors.black,
                            tabs: [
                              Tab(
                                text: 'SIM 1',
                              ),
                              Tab(
                                text: 'SIM 2',
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: TabBarView(children: <Widget>[
                  Test(
                    database: widget.database,
                  ),
                  sim2(
                    database: widget.database,
                  )
                ]))
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color.fromARGB(255, 84, 194, 221),
          onPressed: () {
            opendialog(usssdcontroller, libelercontroller, testcontrollers);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => Details()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Future opendialog(
          TextEditingController libelercontroller,
          TextEditingController usssdcontroller,
          testcontroller testcontrollers) =>
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
                        decoration:
                            InputDecoration(hintText: "Entrer le libeler"),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: usssdcontroller,
                        decoration:
                            InputDecoration(hintText: "Entrer le code ussd"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Envoyer'),
                    onPressed: () {
                      test ussdinsert = test(
                          id: 1,
                          libeler: libelercontroller.text,
                          codeussd: usssdcontroller.text,
                          simchoice: garfe);
                      // postussdcode1(
                      //     libelercontroller, usssdcontroller, testcontrollers);
                      postussdcode1(ussdinsert);
                    },
                  )
                ],
              ));

  void submit() {
    Navigator.of(context).pop();
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

  void postussdcode(
      TextEditingController libelercontroller,
      TextEditingController usssdcontroller,
      testcontroller testcontrollers) async {
    print(libelercontroller.text);
    print(usssdcontroller.text);
    print(garfe);
    var resp = await http.post(
      Uri.parse('https://backend-shop.benindigital.com/addussd'),
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
      testcontrollers.readallnote();
    });

    show_FlushbarHelper(context, resp.body);
  }

  Future<void> postussdcode1(test ussd) async {
    final ussdController = Get.put(ussdcontroller());
    ussdController.postussdcode1(
        ussd, ussdController.ussdlist, widget.database);
    submit();
    print("babba");
    show_FlushbarHelper(context, "resp.body");
    //return ussd.copy(id: id);
  }
}
