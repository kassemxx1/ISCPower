import 'package:get/get.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import '../Counter_Screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
class GetNotCountred extends GetxController{
  List<String> suggestions = [];
  var TempList = [];
  var Clients = [];
  var Value = '';
  var Type = '';
  var ID = '';
  var phone='';
  bool loading = false;
  var lastUpdate = '';
  String last ='';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   getnotfilled();
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


  bool checkifnum(String Numb) {
    if (int.tryParse(Numb) == null) {
      return true;
    } else {
      return false;
    }
  }
  // get the months number

  //get the suggestion list of clients



//get all info for selected value to enter the new counter

  //get all the clients not filled counter
  void getnotfilled() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allclients').toString());
    TempList.clear();
    setcontname(String n) {
      var n = TextEditingController();
      return n;
    }
    String getphone(String idd){

      for (var i in Clients){
        if (i['id']==idd){
          return i['phone'];
        }
        else{
          return '';
        }
      }
      return '';
    }

    var url = Uri.parse(UrlHeroku.toString() + 'getcounters');
    Map<String, dynamic> bbb = {
      'Option': 7,
      'CodeId': '',
      'month': int.tryParse(_prefs.getString('monthnumber').toString()),
    };
    try {
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      if (data['recordsets'][0].length > 0 && data['recordsets'][0].length <100  ) {
        for (var i in data['recordsets'][0]) {
          TempList.add(client(
            false,
            i['clientcode'].toString(),
            i['clientName'].toString(),
            i['prevCtr'].toString(),
            i['newCtr'].toString(),
            setcontname(
                'controller' + Clients.indexOf(i).toString()),

            getphone(i['clientcode'].toString()),
            false,
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
      if (data['recordsets'][0].length > 100){
        Fluttertoast.showToast(
            msg: "يوجد اكثر من ١٠٠ اسم غير مدخل",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);
      }

      if (data['rowsAffected'][0].toString() == '0') {
        Fluttertoast.showToast(
            msg: "Completed or not allowed",
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
      EasyLoading.dismiss();
    }

    EasyLoading.dismiss();
    update();
  }

  void setvalidatetrue(int vali,int kkk){
    vali= 1;
    print(vali);

    update();

  }
  void getphone(String idd) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var list = json.decode(_prefs.getString('allclients').toString());
    for(var i in list){
      if(idd == i['id']){
        phone=i['phone'].toString();
      }
    }
    update();
  }
}