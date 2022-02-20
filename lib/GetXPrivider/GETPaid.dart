import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import '../Paid_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetPaid extends GetxController{
  var paid=[];
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getpaid();
  }
  void getpaid() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    EasyLoading.show();
    paid.clear();
    var url = Uri.parse(UrlHeroku + 'getcounters');
    Map<String, dynamic> bbb = {
      'Option': 8,
      'CodeId': '',
      'month':int.tryParse(_prefs.getString('monthnumber').toString()),

    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['recordsets'].length > 0) {
        for (var i in data['recordsets'][0]) {
           paid.add(paidclient(
             i['clientName'].toString(),
             i['Narration'].toString(),
             i['fctnbr'].toString(),
             i['balance'].toString(),
          ));
          Fluttertoast.showToast(
              msg: "success",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);

          EasyLoading.dismiss();
        }
      }
      if (data['recordsets'].length == 0) {
        Fluttertoast.showToast(
            msg: "غير مسموح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (err) {
      Fluttertoast.showToast(
          msg: "internet problem",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      print(err);
      EasyLoading.dismiss();
    }

    EasyLoading.dismiss();
    update();
  }
}

