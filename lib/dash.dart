import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/Detailss.dart';
import 'package:ussd_code_app/addmarchand.dart';
import 'package:ussd_code_app/bodymarchand.dart';
import 'package:ussd_code_app/controllers/marchand_controller.dart';
import 'package:ussd_code_app/controllers/test_controller.dart';
import 'package:ussd_code_app/lastaddussd.dart';
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

class dash extends StatefulWidget {
  final Database database;
  dash({Key? key, required this.database}) : super(key: key);

  @override
  State<dash> createState() => _dashState();
}

class _dashState extends State<dash> {
  final List<Map> myProducts =
      List.generate(4, (index) => {"id": index, "name": "Product $index"})
          .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('dash'),
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height / 5.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Detail()));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6.8,
                        //  width: 100,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 207, 170, 58),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Cron request",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => addmarchant()));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6.8,
                        // width: 100,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 19, 75, 139),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "MOMO PAY",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        )),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 16.5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => lastaddussd(
                                      database: widget.database,
                                    )));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6.8,
                        //  width: 100,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 53, 192, 157),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "Last Ussd",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Details()));
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height / 6.8,
                        // width: 100,
                        decoration: BoxDecoration(
                            color: Color.fromARGB(255, 134, 32, 32),
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                            child: Text(
                          "Test",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                      ),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }
}
