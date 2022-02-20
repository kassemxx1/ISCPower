import 'package:get/get.dart';
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import '../Counter_Screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
class GetCounters extends GetxController{
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
    getlast();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getsuggestion('name');
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  void getclients() async {
    var clientdesc = [];
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    suggestions.clear();
    loading = true;
    var url = Uri.parse(UrlHeroku.toString() + 'getallclientcounter');
    try{

      var response = await http.get(url);
      var data = json.decode(response.body);
      if (data['rowsAffected'][0] >0){
        for (var i in data['recordsets'][0]) {
          var id = i['clientcode'].toString();
          var name = i['clientName'].toString();
          var address = i['address'].toString();
          var box = i['boxcode'].toString();
          var phone = i['smsmobile'].toString();
          var areacode = i['areacode'].toString();

          clientdesc.add({
            'id': id,
            'name': name,
            'address': address,
            'box': box,
            'phone': phone,
            'areacode': areacode,
          });
        }
        _prefs.setString('lastupdate', DateTime.now().toString());
        _prefs.remove('allclients');
        _prefs.setString('allclients', json.encode(clientdesc));
        _prefs.setBool('first', false);
        lastUpdate = formatDate(
            DateTime.parse(_prefs.getString('lastupdate').toString()),
            [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
            ': آخر تحديث';
        EasyLoading.dismiss();
        loading = false;
      }

      else{
        Fluttertoast.showToast(
            msg: "not allowed",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0);

        EasyLoading.dismiss();
      }

    }
    catch(err){
      Fluttertoast.showToast(
          msg: "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);

      EasyLoading.dismiss();
    }
   update();

  }
  void getlast() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('first') == false) {
      lastUpdate = formatDate(
          DateTime.parse(_prefs.getString('lastupdate').toString()),
          [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';
    } else {
      lastUpdate = 'Please Update';
    }
    EasyLoading.dismiss();
    update();
  }
  bool checkifnum(String Numb) {
    if (int.tryParse(Numb) == null) {
      return true;
    } else {
      return false;
    }
  }
  // get the months number
  void getmonth() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(UrlHeroku + 'getmonth');
    var response = await http.get(url);
    var data = json.decode(response.body);
    if (data['rowsAffected'][0] > 0) {
      for (var i in data['recordsets'][0]) {
        _prefs.setString('monthnumber', i['ctrMonth'].toString());
      }
    }
    update();
  }
  //get the suggestion list of clients
  void getsuggestion(String type) async {
    Type = type;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allclients').toString());

    suggestions.clear();
    for (var i in Clients) {
      if (type == 'name') {
     suggestions.add(i['name'].toString());
      }
      if (type == 'box') {
       suggestions.add(i['box'].toString());
      }
      if (type == 'id') {
        suggestions.add(i['id'].toString());
      }
    }
    Counter_Screen.SearchController.text = ' ';
    Value='';
    Counter_Screen.SearchController.clear();
    update();
  }

  void setInfo(String value) async {
    Value = value;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allclients').toString());
    for (var i in Clients) {
      if (i['name'] == value) {
      ID = i['id'];
      }
    }

    update();
  }
//get all info for selected value to enter the new counter
  void GetInfo(String value, String Type) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allclients').toString());
    EasyLoading.show();
    TempList.clear();
    setcontname(String n) {
      var n = TextEditingController();
      return n;
    }
    String getphone(String idd){

      for (var i in Clients){
        if (i['id']==idd){
          print(i['phone']);
          return i['phone'];

        }
        else{
          return '';
        }
      }
      return '';
    }

    var url = Uri.parse(UrlHeroku + 'getcounters');
    Map<String, dynamic> bbb = {
      'Option': Type == 'box' ? 2 : 1,
      'CodeId': Type == 'name' ? ID : Value,
      'month': int.tryParse(_prefs.getString('monthnumber').toString()),

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
          TempList.add(client(
            false,
            i['clientcode'].toString(),
            i['clientName'].toString(),
            i['prevCtr'].toString(),
            i['newCtr'].toString(),
            setcontname(
                'controller' + Clients.indexOf(i).toString()),

            getphone(i['clientcode'].toString()),

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
      if (data['recordsets'][0].length > 0) {
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
  void setvalidatefalse(bool vali){
    vali= false;
   update();
  }
  void setvalidatetrue(bool vali){
    vali = true;
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