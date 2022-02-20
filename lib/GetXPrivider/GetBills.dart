import 'package:get/get.dart';
import 'dart:convert';
import 'package:date_format/date_format.dart';


import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../Bills_Screen.dart';
import '../Constants.dart';
import '../Main_Screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
class GetBills extends GetxController{
  List<String> suggestions = [];
  var TempList = [];
  var Clients = [];
  var Value = '';
  var Type = 'names';
  var ID = '';
  bool loading = false;
  var lastbill = '';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getlast();
    getbillsuggestion('names');
  }
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
  //Get the info of all bills
  void getallBills() async {
    var clientdesc = [];
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    clientdesc.clear();
    suggestions.clear();
    loading = true;
    var url = Uri.parse(UrlHeroku + 'getbills');
    try {
      var response = await http.get(url);
      var data = json.decode(response.body);
      for (var i in data['recordsets'][0]) {
        var monthnumb = i['schMonth'].toString();
        var yearnumb = i['schYear'].toString();
        var clientcode = i['ClientCode'].toString();
        var names = i['Names'].toString();
        var billnumb = i['fctnbr'].toString();
        var smsmobile = i['smsmobile'].toString();
        var PrevCounter = i['PrevCounter'].toString();
        var CurCounter = i['CurCounter'].toString();
        var FixCost = i['FixCost'].toString();
        var CtrQty = i['CtrQty'].toString();
        var XtraQty = i['XtraQty'].toString();
        var Uprice = i['Uprice'].toString();

        clientdesc.add({
          'monthnumb': monthnumb,
          'yearnumb': yearnumb,
          'clientcode': clientcode,
          'names': names,
          'billnumb': billnumb,
          'smsmobile': smsmobile,
          'PrevCounter': PrevCounter,
          'CurCounter': CurCounter,
          'FixCost': FixCost,
          'CtrQty': CtrQty,
          'XtraQty': XtraQty,
          'Uprice': Uprice,
        });
      }
      _prefs.setString('lastupdatebill', DateTime.now().toString());
      _prefs.remove('allbills');
      _prefs.setString('allbills', json.encode(clientdesc));
      _prefs.setBool('second', false);

      lastbill = formatDate(
          DateTime.parse(_prefs.getString('lastupdatebill').toString()),
          [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';

      EasyLoading.dismiss();
      print(data);
      loading = false;
    } catch (err) {
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
    update();
  }
//get the suggestion list of bills
  void getbillsuggestion(String type) async {
    suggestions.clear();
    TempList.clear();
    Value='';
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allbills').toString());
    for (var i in Clients) {
      if (type == 'names') {
        suggestions.add(i['names'].toString());
      }
      if (type == 'clientcode') {
        suggestions.add(i['clientcode'].toString());
      }
      if (type == 'billnumb') {
        suggestions.add(i['billnumb'].toString());
      }
    }
    Bills_Screen.SearchController.text = ' ';
    Bills_Screen.SearchController.clear();
    EasyLoading.dismiss();
    update();
  }
// set the value and get the id of selected client
  void setInfobill(String value, String type) async {
          Value = value;
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var Clients = json.decode(_prefs.getString('allbills').toString());
    if (type == 'names') {
      for (var i in Clients) {
        if (i['names'] == value) {
          ID = i['clientcode'].toString();
        }
      }
      print(ID);
    }
    if (type == 'billnumb') {
      for (var i in Clients) {
        if (i['billnumb'] == value) {
          ID = i['clientcode'].toString();
        }
      }
    }
    if (type == 'clientcode') {
          ID = value;
    }
    update();
  }
// get the specific bill of selected client
  void getBill(String id) async {
    EasyLoading.show();
      TempList.clear();
    var url = Uri.parse(UrlHeroku + 'getSpecificbill');
    try {
      Map<String, dynamic> bbb = {
        'year': DateTime.now().year,
        'month': 2,
        'id': ID,
      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      print(data);
      for (var i in data['recordsets'][0]) {
            TempList.add(Bill(
            i['ClientCode'].toString(),
            i['Names'].toString(),
            i['schMonth'].toString(),
            i['schYear'].toString(),
            i['balance'].toString(),
            i['netAmount'].toString(),
            i['fctnbr'].toString(),
            i['MonthAr'],
            i['AccountCode'].toString(),
            i['schType'].toString(),
            i['schNumber'].toString(),
            i['PrevCounter'].toString(),
            i['CurCounter'].toString(),
            i['Uprice'].toString()));
      }
      EasyLoading.dismiss();
    } catch (err) {
      print(err);
      EasyLoading.dismiss();
    }
    EasyLoading.dismiss();
    update();
  }
  void getlast() async {
    EasyLoading.show();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if (_prefs.getBool('first') == false) {
      lastbill = formatDate(
          DateTime.parse(_prefs.getString('lastupdatebill').toString()),
          [hh, ':', nn, ' ', dd, '-', mm, '-', yyyy]) +
          ': آخر تحديث';
    } else {
      lastbill = 'Please Update';
    }
    EasyLoading.dismiss();
    update();
  }
}