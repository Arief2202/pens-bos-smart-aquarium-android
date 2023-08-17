// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, unused_import, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pens_bos_smart_aquarium/global_variables.dart' as globals;
import 'package:pens_bos_smart_aquarium/manajemen_air.dart';
import 'package:pens_bos_smart_aquarium/cctv.dart';
import 'package:pens_bos_smart_aquarium/jadwal_pakan.dart';
import 'package:pens_bos_smart_aquarium/class/Json.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> {
  Timer? timer;
  String suhu_air = "0";
  String suhu_ruangan = "0";
  String ph_air = "0";
  String kekeruhan_air = "0";
  String timestamp = "0";
  DateTime tempDate = DateTime(2023, 7, 24, 7, 0, 0);

  @override
  void initState() {
    timer =
        Timer.periodic(Duration(milliseconds: 100), (Timer t) => updateValue());
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
    if (this.mounted) {
      setState(() {
        globals.responseCode = response.statusCode;
      });
    }

    if (response.statusCode == 200) {
      var respon = Json.tryDecode(response.body);
      if(respon == null){
        if (this.mounted) {
          setState(() {
              suhu_air = " ";
              suhu_ruangan = " ";
              ph_air = " ";
              kekeruhan_air = " ";
        });
        }
      }
      else{
        if (this.mounted) {
          setState(() {
            if (respon['data_latest'] != null && respon['data_latest'] != "") {
              suhu_air = respon['data_latest']['suhu_air'];
              suhu_ruangan = respon['data_latest']['suhu_ruangan'];
              ph_air = respon['data_latest']['ph_air'];
              kekeruhan_air = respon['data_latest']['kekeruhan_air'];
              timestamp = respon['data_latest']['timestamp'];
              tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(timestamp);
            }

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
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text("Bos Smarts Aquarium"),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                Alert(
                  context: context,
                  type: AlertType.warning,
                  desc: "\nDo you want to Logout ?",
                  buttons: [
                    DialogButton(
                        child: Text(
                          "No",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () {
                          Phoenix.rebirth(context);
                        }),
                    DialogButton(
                        child: Text(
                          "Yes",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('username');
                          await prefs.remove('password');
                          setState(() {
                            globals.isLoggedIn = false;
                          });
                          Phoenix.rebirth(context);
                        }),
                  ],
                ).show();
              })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 20.0), //SizedBox(height: 20.0),
          Card(
            child: Container(
              width: MediaQuery.of(context).size.width - 50,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Endpoint ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Response Code      ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          " : ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " : ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          globals.endpoint,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          "${globals.responseCode}",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                      ],
                    ),
                  ]),
                  Container(height: 20),


                  Row(
                    children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Suhu Ruangan ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Temperatur Air ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tingkat PH Air ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tingkat Kekeruhan ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Timestamp",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Tanggal ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Jam ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          " :  ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " :  ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " :  ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " :  ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " :  ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          " :  ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          suhu_ruangan,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          suhu_air,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          ph_air,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          kekeruhan_air,
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy').format(tempDate),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          DateFormat('hh:mm:ss').format(tempDate),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          " °C",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " °C",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " pH",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          "   NTU",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          " ",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                        Text(
                          DateFormat('a').format(tempDate),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: globals.valueColor),
                        ),
                      ],
                    ),
                  ]),
                ],
              ),
            ),
          ),
          Container(height: 20.0), //SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageButton(
                image: 'assets/img/valve_dark.png',
                title: 'Manajemen Air',
                margin: EdgeInsets.only(right: 40),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ManajemenAir();
                  }));
                },
              ),
              ImageButton(
                image: 'assets/img/feed_dark.png',
                title: 'Jadwal Pakan',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return JadwalPakan();
                  }));
                },
              ),
            ],
          ),
          Container(height: 20.0), //SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageButton(
                image: 'assets/img/cctv_dark.png',
                title: 'CCTV Aquarium',
                margin: EdgeInsets.only(right: 40),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CCTV();
                  }));
                },
              ),
              ImageButton(
                  image:
                      "assets/img/lamp_${globals.stateLampu ? "on" : "off"}_dark.png",
                  title: 'Lampu',
                  onTap: () async {
                    var url = Uri.parse(globals.endpoint_change_state);
                    final response = await http.post(url, body: {
                      'column': 'lampu',
                      'state': '${globals.stateLampu ? "0" : "1"}'
                    });
                    print(response.statusCode);
                  }),
            ],
          ),
        ],
      ),
    );
  }
}

class ImageButton extends StatelessWidget {
  String image;
  String title;
  VoidCallback onTap;
  EdgeInsets? margin;
  ImageButton(
      {required this.image,
      required this.title,
      required this.onTap,
      this.margin,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 120.0,
      width: 150,
      margin: margin,
      decoration: BoxDecoration(color: globals.baseColor),
      child: Material(
        color: globals.baseColor,
        child: InkWell(
          splashColor: globals.baseColor,
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(height: 20.0),
              Image.asset(image, width: 100, height: 100),
              // Ink.image(
              //   image: AssetImage(image),
              //   width: 90,
              //   height: 90,
              //   // fit: BoxFit.cover,
              // ),
              Container(height: 20.0),
              Text(
                title,
                style: TextStyle(color: Colors.white),
              ),
              Container(height: 10.0),
            ],
          ),
        ),
      ),
    );
  }
}