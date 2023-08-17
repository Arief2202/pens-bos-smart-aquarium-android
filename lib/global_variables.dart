// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names

library global;

import 'package:flutter/material.dart';

const valueColor = Color.fromARGB(255, 11, 12, 75);
const themeColor = Color.fromARGB(255, 11, 12, 75);
// const baseColor = Colors.blueGrey;
const baseColor = MaterialColor(0xff0B114B, <int, Color>{
  50: Color(0xff0B114B),
  100: Color(0xff0B114B),
  200: Color(0xff0B114B),
  300: Color(0xff0B114B),
  400: Color(0xff0B114B),
  500: Color(0xff0B114B),
  600: Color(0xff0B114B),
  700: Color(0xff0B114B),
  800: Color(0xff0B114B),
  900: Color(0xff0B114B),
});

var responseCode = 404;
String endpoint = "bos-smarts.eepis.tech";
String endpoint_create_jadwal = "http://" + endpoint + "/jadwal_pakan/create.php";
String endpoint_delete_jadwal = "http://" + endpoint + "/jadwal_pakan/delete.php";
String endpoint_change_state = "http://" + endpoint + "/changeState.php";

String username = "admin";
String password = "admin";

bool isLoggedIn = false;
bool loadingAutologin = false;

bool statePengisi = false;
bool stateC1 = false;
bool stateC2 = false;
bool stateLampu = false;
late List<dynamic>? data;