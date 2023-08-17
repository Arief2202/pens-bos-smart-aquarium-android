// ignore_for_file: curly_braces_in_flow_control_structures, prefer_const_constructors, sort_child_properties_last, unused_local_variable, unused_import

import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:pens_bos_smart_aquarium/global_variables.dart' as globals;

class CCTV extends StatefulWidget {
  const CCTV({super.key});

  @override
  State<CCTV> createState() => CCTVState();
}

class CCTVState extends State<CCTV> {
  TextEditingController link = TextEditingController();
  bool _isScreenOn = false;
  @override
  void initState() {
    super.initState();
    WebView.platform = AndroidWebView();
    loadLink();
  }
  void loadLink() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? camLink = prefs.getString('camLink');
    final bool? tempScreenOn = prefs.getBool('screenOn');
    if(camLink != null && tempScreenOn != null){
      if (this.mounted) {
        setState(() {
          link.text = camLink!;
          _isScreenOn = tempScreenOn!;
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    saveState();
  }
  void saveState() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('camLink', link.text);
    await prefs.setBool('screenOn', _isScreenOn);
  }

  Widget build(BuildContext context) {
    double mapWidth = MediaQuery.of(context).size.width / 1.2;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            saveState();
            Navigator.pop(context);
          },
        ),
        title: Text("Monitor CCTV"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Link Webcam',
                    labelStyle: TextStyle(fontSize: 20),
                    // errorText: _error[0] ? 'Value Can\'t Be Empty' : null,
                  ),
                  onSubmitted: (value) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('camLink', link.text);
                  },
                  controller: link,
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: (){
                if (this.mounted) {
                  setState(() {
                    if(_isScreenOn) _isScreenOn = false;
                    else _isScreenOn = true;
                  });
                }
                saveState();
              },
              child: Text(
                _isScreenOn ? "Stop" : "Start",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 15),          
          _isScreenOn
            ? Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
                child: WebView(
                  initialUrl: link.text,
                ))
            : Container(
                height: 400,
                width: MediaQuery.of(context).size.width,
              )

          // _isScreenOn
          //   ? Container(
          //       height: 240,
          //       width: 320,
          //       child: WebView(
          //         initialUrl: "http://192.168.225.97",
          //       ))
          //   : Container(
          //       height: 240,
          //       width: 320,
          //     ));
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
