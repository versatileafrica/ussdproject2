import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:ussd_code_app/Details.dart';
import 'package:ussd_code_app/addmarchand.dart';
import 'package:ussd_code_app/dash.dart';
import 'package:ussd_code_app/homescreen.dart';
import 'package:ussd_code_app/lastaddussd.dart';

class appbarmode extends StatelessWidget {
  final Database database;
  const appbarmode({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appli Ussd'),
        backgroundColor: Color.fromARGB(255, 84, 194, 221),
        // Colors.orange[100],
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  // context, MaterialPageRoute(builder: (context) => Detail()));

                  context,
                  MaterialPageRoute(
                      builder: (context) => dash(
                            database: database,
                          )));
              // context,
              // MaterialPageRoute(builder: (context) => addmarchant()));
              // context,
              // MaterialPageRoute(builder: (context) => lastaddussd()));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: homescreen(
        database: database,
      ),
      //ussdcode()
    );
  }
}
