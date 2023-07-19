// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pens_bos_smart_aquarium/global_variables.dart' as globals;

class ManajemenAir extends StatefulWidget {
  const ManajemenAir({super.key});

  @override
  State<ManajemenAir> createState() => ManajemenAirState();
}

class ManajemenAirState extends State<ManajemenAir> {
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width / 1.2;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Manajemen Air"),
        // actions: <Widget>[
        //   IconButton(
        //       icon: const Icon(Icons.logout),
        //       onPressed: () async {
        //         Alert(
        //           context: context,
        //           type: AlertType.warning,
        //           desc: "\nDo you want to Logout ?",
        //           buttons: [
        //             DialogButton(
        //                 child: Text(
        //                   "No",
        //                   style: TextStyle(color: Colors.white, fontSize: 20),
        //                 ),
        //                 onPressed: () {
        //                   Phoenix.rebirth(context);
        //                 }),
        //             DialogButton(
        //                 child: Text(
        //                   "Yes",
        //                   style: TextStyle(color: Colors.white, fontSize: 20),
        //                 ),
        //                 onPressed: () async {
        //                   final prefs = await SharedPreferences.getInstance();
        //                   await prefs.remove('username');
        //                   await prefs.remove('password');
        //                   setState(() {
        //                     globals.isLoggedIn = false;
        //                   });
        //                   Phoenix.rebirth(context);
        //                 }),
        //           ],
        //         ).show();
        //       })
        // ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 15.0), //SizedBox(height: 20.0),
          Text("Pengisian Air"),
          Container(height: 20.0), //SizedBox(height: 20.0),
          Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width - 50,
            child: ElevatedButton(
              child: new Text("On/Off Valve Pengisi Air"),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   // return MonitoringPage();
                // }));
              },
            ),
          ),
          Container(height: 50.0), //SizedBox(height: 20.0),
          Text("Pembuangan Air"),
          Container(height: 15.0), //SizedBox(height: 20.0),
          Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width - 50,
            child: ElevatedButton(
              child: new Text("On/Off Valve Pembuang C1"),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return ListKaryawan();
                // }));
              },
            ),
          ),
          Container(height: 15.0), //SizedBox(height: 20.0),
          Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width - 50,
            child: ElevatedButton(
              child: new Text("On/Off Valve Pembuang C2"),
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return ListKaryawan();
                // }));
              },
            ),
          ),

          // Container(height: 20.0), //SizedBox(height: 20.0),

          // Container(
          //   height: 50.0,
          //   width: 300.0,
          //   child: ElevatedButton(
          //     child: new Text("History Lokasi"),
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return AbsensiPage(id: 1);
          //       }));
          //     },
          //   ),
          // ),

          // Container(height: 20.0), //SizedBox(height: 20.0),

          // Container(
          //   height: 50.0,
          //   width: 300.0,
          //   child: ElevatedButton(
          //     child: new Text("History Presensi"),
          //     onPressed: () {
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return HistoryPresensiPage();
          //       }));
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
