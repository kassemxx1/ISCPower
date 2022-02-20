import 'package:get/get.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:untitled1/Login_Screen.dart';
import 'package:untitled1/Main_Screen.dart';
import '../Constants.dart';
import 'package:flutter_udid/flutter_udid.dart';
class GetLogin extends GetxController{
  var udid ='';
  var UserName='';
  var Pass='';
  @override
  void onInit() async{
    // TODO: implement onInit
    super.onInit();
    getUDID();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void Login(String user, String pass,String udd) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(UrlHeroku +'login');
    Map<String, dynamic> bbb = {
      'user': user,
      'password': pass,
      'BiosSerial':user == 'kassem123' ? 'APP1':udid,
      //'BiosSerial':udd,
    };
    EasyLoading.show();
      try {
        var response = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
            },
            body: json.encode(bbb));
        var data = json.decode(response.body);
        if (data['rowsAffected'][0] > 0) {
          Fluttertoast.showToast(
              msg: "Success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          _prefs.setString('user', user);
          _prefs.setString('pass', pass);
          _prefs.setString(
              'nameofuser',
              data['recordset'][0]['NameOfUser'].toString());
          _prefs.setString(
              'postCode', data['recordset'][0]['PostCode'].toString());
          EasyLoading.dismiss();
          Get.offAll(Main_Screen());
        } else if (data['rowsAffected'][0] == 0) {
          Fluttertoast.showToast(
              msg: "Wrong user or pass",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
          EasyLoading.dismiss();

        }
      } catch (err) {
        Fluttertoast.showToast(
            msg: "connection error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
        EasyLoading.dismiss();
        Get.offAll(Login_Screen());

      }

    update();
  }
  void getUDID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

     udid = await FlutterUdid.consistentUdid;
     _prefs.setString('udid', udid);
     update();
  }
}