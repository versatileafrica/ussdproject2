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

class Test extends StatefulWidget {
  final Database database;
  Test({Key? key, required this.database}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final ussdController = Get.put(ussdcontroller());
  // dependency injection
  // var testcontrollers = (test_repository(), widget.database);

  TextEditingController libelercontroller = TextEditingController();
  TextEditingController usssdcontroller = TextEditingController();

  @override
  void initState() {
    ussdController.readallnote(widget.database);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ussdcontroller>(builder: (c) {
          List<test> ussdList = c.ussdlist;
          print("ok: $ussdList");
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: ussdList.isNotEmpty ? ussdList.length : 1,
            itemBuilder: (context, index) {
              return ussdList.isNotEmpty
                  ? Container(
                      child: Center(
                        child: Text("Lib: ${ussdList[index].libeler}"),
                      ),
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          );
        }),
      ),
    );
  }
}
