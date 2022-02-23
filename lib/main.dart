import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:untitled1/Bills_Screen.dart';
import 'package:untitled1/Counter_Screen.dart';
import 'package:untitled1/Login_Screen.dart';
import 'package:untitled1/Main_Screen.dart';
import 'package:untitled1/Paid_Screen.dart';
import 'package:untitled1/Payment_Screen.dart';
import 'package:untitled1/Splash_Screen.dart';
import 'NotCountred_Screen.dart';


void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: EasyLoading.init(),
      initialRoute: Splash_Screen.id,
      routes: {
        Splash_Screen.id:(context) => Splash_Screen(),
        Login_Screen.id:(context) => Login_Screen(),
        Main_Screen.id:(context) =>Main_Screen(),
        Counter_Screen.id:(context) => Counter_Screen(),
        Bills_Screen.id:(contex) => Bills_Screen(),
        Payment_Screen.id:(context) =>Payment_Screen(),
        Paid_Screen.id:(context) =>Paid_Screen(),
        NotCounterd.id:(context) => NotCounterd(),
      },
    );
  }
}

