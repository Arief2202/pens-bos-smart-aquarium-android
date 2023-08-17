// ignore_for_file: unused_import, unused_field

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonDecode;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:pens_bos_smart_aquarium/global_variables.dart' as globals;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  List<TextEditingController> _data = [TextEditingController(), TextEditingController(), TextEditingController()];
  List<bool> _error = [false, false, false, false];
  String _passwordMsg = "Value Can\'t Be Empty";

  @override
  void initState() {
    super.initState();
    loadEndpoint();
  }

  void loadEndpoint() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? endpoint = prefs.getString('endpoint');    
    if(endpoint != null){      
      if (this.mounted) {
        setState(() {
          _data[2].text = endpoint!;
          globals.responseCode = 404;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: globals.themeColor,
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.vertical,
          children: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                  Image.asset("assets/img/logo.png", width: MediaQuery.of(context).size.width / 1.4),
                  Container(
                    width: MediaQuery.of(context).size.width - 25,
                    // height: 330,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        //set border radius more than 50% of height and width to make circle
                      ),
                      child: Container(
                        padding: EdgeInsets.only(top: 20, bottom: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                                margin: EdgeInsets.symmetric(horizontal: 50),
                                width: double.infinity,
                                // height: MediaQuery.of(context).size.width / 10,
                                child: Text("LOGIN ADMIN", textAlign: TextAlign.center, style: TextStyle(color: globals.baseColor, fontSize: 30, fontWeight: FontWeight.bold))),
                            SizedBox(height: 20),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Endpoint',
                                      labelStyle: TextStyle(fontSize: 20),
                                      errorText: _error[2] ? 'Value Can\'t Be Empty' : null,
                                    ),
                                    onSubmitted: (value) {
                                      _doLogin(context);
                                    },
                                    controller: _data[2],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Username',
                                      labelStyle: TextStyle(fontSize: 20),
                                      errorText: _error[0] ? 'Value Can\'t Be Empty' : null,
                                    ),
                                    onSubmitted: (value) {
                                      _doLogin(context);
                                    },
                                    controller: _data[0],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              //img1
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                      labelStyle: TextStyle(fontSize: 20),
                                      errorText: _error[1] ? 'Value Can\'t Be Empty' : null,
                                    ),
                                    onSubmitted: (value) {
                                      _doLogin(context);
                                    },
                                    controller: _data[1],
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
                                onPressed: () {
                                  _doLogin(context);
                                },
                                child: Text(
                                  "Log in",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ])),
          ],
        ),
      ),
    );
  }

  Future _doLogin(context) async {
    bool status = true;
    setState(() {
      _passwordMsg = "Value Can\'t Be Empty";
      for (int a = 0; a < 3; a++) {
        if (_data[a].text.isEmpty) {
          _error[a] = true;
          status = false;
        } else
          _error[a] = false;
      }
    });
    if (status) {
      String _username = _data[0].text;
      String _password = _data[1].text;
      String _endpoint = _data[2].text;

      if (_username == globals.username && _password == globals.password) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', _username);
        await prefs.setString('password', _password);
        await prefs.setString('endpoint', _endpoint);
        setState(() {
          globals.isLoggedIn = true;
          globals.endpoint = _endpoint;
          globals.responseCode = 404;
        });
        Alert(
          context: context,
          type: AlertType.success,
          desc: "\nLogin Success!",
          buttons: [
            DialogButton(
                child: Text(
                  "OK",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  Phoenix.rebirth(context);
                })
          ],
        ).show();
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          title: "Login Failed!",
          desc: "Incorrect Username or Password!",
          buttons: [
            DialogButton(
              child: Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () => Navigator.pop(context),
            )
          ],
        ).show();
      }
    }
  }
}
