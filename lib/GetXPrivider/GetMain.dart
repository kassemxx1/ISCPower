import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_udid/flutter_udid.dart';
class GetMain extends GetxController{
  var counter ='';
  var totalcounter ='';
  var balance='0';
  var bill = '';
  var totalbill='';
  var name ='';
  var user='';
  var udid='';

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getrecords(3);
    getrecords(4);
    getbalance();
    getinformation();
    getUDID();
  }
  void getrecords(int option) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(UrlHeroku + 'getcounters');
    try {
      Map<String, dynamic> bbb = {
        'id':'',
        'month':int.tryParse(_prefs.getString('monthnumber').toString()),
      //  'month':2,
        'Option':option,

      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      print(data);
      for(var i in data['recordsets'][0]){
        if(option == 3){
          counter = i['Countred'].toString();
          totalcounter=i['ClientCount'].toString();
        }
        if(option ==4){
          bill = i['Countred'].toString();
          totalbill=i['ClientCount'].toString();
        }

      }
    }
    catch (err){
      print(err);
    }
    update();
  }
  void getbalance( ) async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    var url = Uri.parse(UrlHeroku + 'getbalance');
    try{
      Map<String, dynamic> bbb = {
        'Option':1,
        'user':_prefs.getString('user'),
        'PostCode':_prefs.getString('postCode'),
        'month':_prefs.getString('monthnumber'),
        'year':2022,
      };
      var response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          },
          body: json.encode(bbb));
      var data = json.decode(response.body);
      print(data);
      for(var i in data['recordsets'][0]){
        if(i['UserBalance'].toString() == null){
          balance = 'لا يوجد';
        }
        else{

          balance = i['UserBalance'].toString();
        }


      }


    }
    catch(err){

    }
    update();
  }
  void getinformation() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    name = _prefs.getString('nameofuser').toString();
    user = _prefs.getString('user').toString();

  }
  void getUDID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();

    udid = await FlutterUdid.consistentUdid;
    _prefs.setString('udid', udid);
    update();
  }
}