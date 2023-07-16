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

String endpoint = "http://absensi.ppns.eepis.tech";
String endpoint_get_all = endpoint + "/location/get_all.php";
String endpoint_list_karyawan_get_all = endpoint + "/user/get_all.php";
String endpoint_monitor_karyawan_get_all = endpoint + "/monitor_karyawan/get_all.php";
String endpoint_history_presensi_get_all = endpoint + "/history_presensi/get_all.php";

String username = "admin";
String password = "admin";

bool isLoggedIn = false;
bool loadingAutologin = false;
