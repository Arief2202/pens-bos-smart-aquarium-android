// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pens_bos_smart_aquarium/global_variables.dart' as globals;
import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:pens_bos_smart_aquarium/class/Json.dart';

class ManajemenAir extends StatefulWidget {
  const ManajemenAir({super.key});

  @override
  State<ManajemenAir> createState() => ManajemenAirState();
}

class ManajemenAirState extends State<ManajemenAir> {  
  Timer? timer;
  
  @override
  void initState() {
    timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateValue());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void updateValue() async {
    var url = Uri.parse("http://${globals.endpoint}/");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var respon = Json.tryDecode(response.body);
      if(respon == null){
        if (this.mounted) {
          setState(() {
              globals.statePengisi = false;
              globals.stateC1 = false;
              globals.stateC2 = false;
              globals.stateLampu = false;
              globals.data = null;
          });
        }
      }
      else{
        if (this.mounted) {
          setState(() {
            if (respon['jadwal_pakan_flutter'] != null &&
                respon['jadwal_pakan_flutter'] != "") {
              globals.data =
                  List<dynamic>.from((respon['jadwal_pakan_flutter']) as List);
            }

            if (respon['state_latest'] != null && respon['state_latest'] != "") {
              globals.statePengisi =
                  respon['state_latest']['pengisi_air'] == "1" ? true : false;
              globals.stateC1 =
                  respon['state_latest']['pembuang_c1'] == "1" ? true : false;
              globals.stateC2 =
                  respon['state_latest']['pembuang_c2'] == "1" ? true : false;
              globals.stateLampu =
                  respon['state_latest']['lampu'] == "1" ? true : false;
            }
          });
        }
      }
    }
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
              child: new Text("On/Off Valve Pengisi Air (${globals.statePengisi ? "ON" : "OFF"})"),
              onPressed: ()  async{            
                var url = Uri.parse(globals.endpoint_change_state);
                final response = await http.post(url, body: {'column': 'pengisi_air', 'state': '${globals.statePengisi ? "0" : "1"}'});
                print(response.statusCode);
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
              child: new Text("On/Off Valve Pembuang C1 (${globals.stateC1 ? "ON" : "OFF"})"),
              onPressed: ()  async{            
                var url = Uri.parse(globals.endpoint_change_state);
                final response = await http.post(url, body: {'column': 'pembuang_c1', 'state': '${globals.stateC1 ? "0" : "1"}'});
                print(response.statusCode);
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
              child: new Text("On/Off Valve Pembuang C2 (${globals.stateC2 ? "ON" : "OFF"})"),
              onPressed: ()  async{            
                var url = Uri.parse(globals.endpoint_change_state);
                final response = await http.post(url, body: {'column': 'pembuang_c2', 'state': '${globals.stateC2 ? "0" : "1"}'});
                print(response.statusCode);
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
