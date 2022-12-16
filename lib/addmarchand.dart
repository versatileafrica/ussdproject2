import 'package:flutter/material.dart';
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

late int garfe = 0;
late bool garf = true;

class addmarchant extends StatefulWidget {
  addmarchant({Key? key}) : super(key: key);

  @override
  State<addmarchant> createState() => _addmarchantState();
}

class _addmarchantState extends State<addmarchant> {
  @override
  Widget build(BuildContext context) {
    // var testcontrollers = testcontroller(test_repository());
    var marchcontrollers = marchandcontroller(marchand_repository());
    TextEditingController libelercontroller = TextEditingController();
    TextEditingController usssdcontroller = TextEditingController();

    Future loadlist() async {
      setState(() {
        marchcontrollers.gettestlist();
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
        title: const Text('MOMO PAY'),
        actions: [
          LiteRollingSwitch(
            //initial value
            value: true,
            textOn: 'Sim1',
            textOff: 'Sim2',
            colorOn: Colors.greenAccent[700],
            colorOff: Colors.redAccent[700],
            iconOn: Icons.done,
            iconOff: Icons.remove_circle_outline,
            textSize: 16.0,
            onChanged: (bool state) {
              //Use it to manage the different states
              print('Current State of SWITCH IS: $state');
              // setState(() {
              //   garf = state;
              // });
            },
          ),
        ],
      ),
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
          ),
          Text(
            'Listes Des Marchands',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: Container(
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
                            child: builbodycontent(snapshot, marchcontrollers));
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
        onPressed: () {
          opendialog(usssdcontroller, libelercontroller, marchcontrollers);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Details()));
        },
        child: Icon(Icons.add),
      ),
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
        height: double.maxFinite,
        child: ListView.separated(
            padding: EdgeInsets.all(8),
            scrollDirection: Axis.vertical,
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

  Future opendialog(
          TextEditingController libelercontroller,
          TextEditingController usssdcontroller,
          marchandcontroller testcontrollers) =>
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
                        decoration: InputDecoration(
                            hintText: "Entrer le Nom du marchand"),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 41.25,
                      ),
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: usssdcontroller,
                        decoration: InputDecoration(
                            hintText: "Entrer l'id du marchand"),
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    child: Text('Envoyer'),
                    onPressed: () {
                      postussdcode(
                          libelercontroller, usssdcontroller, testcontrollers);
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

  void postussdcode(
      TextEditingController libelercontroller,
      TextEditingController usssdcontroller,
      marchandcontroller testcontrollers) async {
    print(libelercontroller.text);
    print(usssdcontroller.text);
    //print(garfe);
    if (garf) {
      setState(() {
        garfe = 0;
      });
    } else {
      garfe = 1;
    }
    print(garfe);
    var resp = await http.post(
      Uri.parse('https://backend-shop.benindigital.com/addmarchand'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "nommarchand": libelercontroller.text,
        "idmarchand": usssdcontroller.text,
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

    abor(context, resp.body);
  }
}
