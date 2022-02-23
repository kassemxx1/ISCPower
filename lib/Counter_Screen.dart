import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:untitled1/GetXPrivider/GetCounters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:untitled1/Constants.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
class Counter_Screen extends StatelessWidget {
  static const String id = 'Counter_Screen';
  static TextEditingController SearchController = TextEditingController();
  const Counter_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counters',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          GetBuilder<GetCounters>(
            init: GetCounters(),
            builder: (val) => IconButton(
                onPressed: () {
                  val.getclients();
                  val.getmonth();
                },
                icon: Icon(
                  Icons.refresh,
                  size: 40,
                )),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: GetBuilder<GetCounters>(
        init: GetCounters(),
        builder: (val)=> ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2),
                ),
                child: Card(
                  elevation: 20,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                              val.lastUpdate,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                      ),
                      CustomRadioButton(
                        height: 40,
                        width: 120,
                        defaultSelected: 'name',
                        enableShape: false,
                        elevation: 0,
                        absoluteZeroSpacing: true,
                        unSelectedColor: Colors.white,
                        selectedBorderColor: Colors.grey,
                        buttonLables: [
                          'name',
                          'box',
                          'id',
                        ],
                        buttonValues: [
                          "name",
                          "box",
                          "id",
                        ],
                        buttonTextStyle: ButtonTextStyle(
                            selectedColor: Colors.white,
                            unSelectedColor: Colors.black,
                            textStyle: TextStyle(
                                fontSize: 16, color: Colors.white)),
                        radioButtonValue: (value) {
                          val.Type = value.toString();
                          val.TempList.clear();
                          val.getsuggestion(value.toString());
                        },
                        selectedColor: Theme.of(context).backgroundColor,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: EasyAutocomplete(
                            controller: SearchController,
                            suggestions: val.suggestions,
                            autofocus: false,
                            onChanged: (value) {
                              val.setInfo(value);
                            },
                          )),
                      Container(
                        height: 40,
                        child: Center(
                          child: Text(
                            val.Value,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Card(
                          elevation: 20,
                          child: Container(
                            color: Colors.blue,
                            width: MediaQuery.of(context).size.width / 3,
                            child: MaterialButton(
                              child: Text('Get',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                SearchController.clear();
                                val.GetInfo(val.Value, val.Type);


                                // blocpro.GetInfo(Counter_Screen.Value,
                                //     Counter_Screen.Type);
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                border: TableBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                horizontalMargin: 2,
                dividerThickness: 5,
                decoration: BoxDecoration(
                    color: Colors.white, border: Border.all(width: 1)),
                dataRowHeight: MediaQuery.of(context).size.height / 8,
                columns: [
                  DataColumn(
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 3,
                                  child: Center(
                                      child: Column(
                                        children: [
                                          Text(
                                            'Name',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Old Counter',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ))),
                              Expanded(
                                flex: 3,
                                child: Center(
                                    child: Text('New Counter',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ))),
                              ),
                              Expanded(
                                flex: 4,
                                child: Center(
                                    child: Text('#',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ))),
                              )
                            ],
                          ),
                        ),
                      )),
                ],
                rows: val.TempList.map((client) =>
                    DataRow(selected: true, cells: [
                      DataCell(
                          Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.grey, width: 2),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Text(
                                            client.name,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Center(
                                            child: Text(
                                              client.LastCounter,
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20),
                                            )),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 3,
                                      child: TextField(
                                        onChanged: (value) {


                                          // blocpro.setvalidatefalse(
                                          //     client._validate);
                                        },
                                        controller: client.cont,
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          hintText: client.CurrentCounter
                                              .toString(),
                                          errorText: client.valid==true
                                              ? 'Wrong Input'
                                              : null,
                                        ),
                                        keyboardType: TextInputType.number,
                                      )),
                                  Expanded(
                                    flex: 4,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        val.validate(client.cont, client.LastCounter,client.valid);


                                        if (val.checkifnum(client.cont.text
                                            .toString()) ==
                                            true ||
                                            int.parse(client.cont.text) <=
                                                int.parse(
                                                    client.LastCounter)) {


                                        } else {


                                          SharedPreferences _prefs =
                                          await SharedPreferences
                                              .getInstance();
                                          EasyLoading.show();
                                          var url = Uri.parse(
                                              UrlHeroku + 'transaction');

                                          Map<String, dynamic> bbb = {
                                            'id': client.id.toString(),
                                            'counter':
                                            int.parse(client.cont.text),
                                            'userName': _prefs
                                                .getString('user')
                                                .toString(),
                                          };
                                          try {
                                            var response = await http.post(
                                                url,
                                                headers: <String, String>{
                                                  'Content-Type':
                                                  'application/x-www-form-urlencoded; charset=UTF-8',
                                                },
                                                body: json.encode(bbb));
                                            var data =
                                            json.decode(response.body);
                                            if (data['state'] == 1) {
                                              Fluttertoast.showToast(
                                                  msg: "Success",
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                  Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              // client.cont.clear();
                                              EasyLoading.dismiss();
                                            }
                                            if (data['state'] == 2) {
                                              Fluttertoast.showToast(
                                                  msg: "error",
                                                  toastLength:
                                                  Toast.LENGTH_SHORT,
                                                  gravity:
                                                  ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor:
                                                  Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              EasyLoading.dismiss();
                                            }
                                          } catch (err) {
                                            Fluttertoast.showToast(
                                                msg: "internet problem",
                                                toastLength:
                                                Toast.LENGTH_SHORT,
                                                gravity:
                                                ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor:
                                                Colors.grey,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                            EasyLoading.dismiss();
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Submit',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontSize: 20),
                                      ),
                                    ),
                                  )
                                ],
                              )), onLongPress: () {
                            val.getphone(client.id);



                        //print(getPhone(client.id));

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    children: [
                                      Text( client.id),
                                      Text( client.name),
                                      Text(val.phone),
                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  MaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('done'),
                                  )
                                ],
                              );
                            });
                      }),
                    ])).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class client {
  bool valid;
  String id;
  String name;
  String LastCounter;
  String CurrentCounter;
  TextEditingController cont;
  String phone;
  client(this.valid,this.id, this.name, this.LastCounter, this.CurrentCounter, this.cont,
       this.phone);
}
