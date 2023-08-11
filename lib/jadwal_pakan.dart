// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pens_bos_smart_aquarium/global_variables.dart' as globals;
import 'package:horizontal_data_table/horizontal_data_table.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;

const List<String> list = <String>[
  'Senin',
  'Selasa',
  'Rabu',
  'Kamis',
  'Jumat',
  'Sabtu',
  'Minggu'
];
var hari = list.first;
var jam = "";

class JadwalPakan extends StatefulWidget {
  const JadwalPakan({super.key});

  @override
  State<JadwalPakan> createState() => JadwalPakanState();
}

class JadwalPakanState extends State<JadwalPakan> {
  Timer? timer;
  TextEditingController timeinput = TextEditingController();
  
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
    var url = Uri.parse("http://bos-smarts.eepis.tech/");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var respon = jsonDecode(response.body);
      if (this.mounted) {
        setState(() {        
          globals.data = List<dynamic>.from((respon['jadwal_pakan_flutter']) as List);
          globals.statePengisi = respon['state_latest']['pengisi_air'] == "1" ? true : false;
          globals.stateC1 = respon['state_latest']['pembuang_c1'] == "1" ? true : false;
          globals.stateC2 = respon['state_latest']['pembuang_c2'] == "1" ? true : false;
          globals.stateLampu = respon['state_latest']['lampu'] == "1" ? true : false;
          // userLocation = List<UserLocation>.from((jsonDecode(response.body) as List).map((x) => UserLocation.fromJson(x)).where((content) => content.nuid != null));
        });
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
        title: Text("Jadwal Pakan"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(height: 20.0), //SizedBox(height: 20.0),

          Container(
            height: 50.0,
            width: 300.0,
            child: ElevatedButton(
              child: new Text("Tambahkan Jadwal"),
              onPressed: () {
                Alert(
                    context: context,
                    title: "Tambahkan Jadwal",
                    content: Column(
                      children: <Widget>[
                        DropdownButtonExample(),
                        TextField(
                          controller:
                              timeinput, //editing controller of this TextField
                          decoration: InputDecoration(
                              icon: Icon(Icons.timer), //icon of text field
                              labelText: "Enter Time" //label text of field
                              ),
                          readOnly:
                              true, //set it true, so that user will not able to edit text
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              print(
                                  pickedTime.format(context)); //output 10:51 PM
                              DateTime parsedTime = new DateFormat("hh:mm")
                                  .parse(pickedTime.format(context).toString());
                              // //converting to DateTime so that we can further format on different pattern.
                              // print(parsedTime); //output 1970-01-01 22:53:00.000
                              String formattedTime =
                                  DateFormat('HH:mm:ss').format(parsedTime);
                              // print(formattedTime); //output 14:59:00
                              // //DateFormat() is from intl package, you can format the time on any pattern you need.

                              setState(() {
                                timeinput.text =
                                    formattedTime; //set the value of text field.
                                jam = formattedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        )
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        onPressed: () async{
                          var url = Uri.parse(globals.endpoint_create_jadwal);
                          final response = await http.post(url, body: {'hari': hari, 'jam': jam});
                          print(hari);
                          print(jam);
                          print(response.statusCode);
                          // context.loaderOverlay.hide();
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Tambahkan",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      )
                    ]).show();
                // Navigator.push(context, MaterialPageRoute(builder: (context) {
                //   return AbsensiPage(id: 1);
                // }));
              },
            ),
          ),

          Container(height: 20.0), //SizedBox(height: 20.0),
          Container(
            height: MediaQuery.of(context).size.height - 200,
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Stack(children: <Widget>[
                  Column(children: [
                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Text('Hari'),
                          ),
                          // DataColumn(
                          //   label: Text('Name'),
                          // ),
                          // DataColumn(
                          //   label: Text('Pesan'),
                          // ),
                          DataColumn(
                            label: Text('Jam'),
                          ),
                          DataColumn(
                            label: Text('Aksi'),
                          ),
                        ],
                        rows: List.generate(globals.data!.length, (index) {
                          final item = globals.data![index];
                          return DataRow(
                            cells: [
                              DataCell(Text(item['hari'],
                                  style: TextStyle(color: Colors.black))),
                              DataCell(Text(item['jam'],
                                  style: TextStyle(color: Colors.black))),
                              DataCell(ElevatedButton(
                                  child: new Text("Hapus"), onPressed: () async{                                  
                                    var url = Uri.parse(globals.endpoint_delete_jadwal);
                                    final response = await http.post(url, body: {'id': item['id']});
                                  })),
                              // DataCell(Text("Dummy", style: TextStyle(color: Colors.black))),
                              // DataCell(Text("Dummy", style: TextStyle(color: Colors.black))),
                              // DataCell(Text("Dummy", style: TextStyle(color: Colors.black))),
                            ],
                          );
                        }),
                      ),
                    ),
                  ])
                ])) ,
          )
        ],
      ),
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      isExpanded: true,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: globals.baseColor),
      underline: Container(
        height: 2,
        color: globals.baseColor,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          hari = dropdownValue;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
