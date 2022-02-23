import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/GetXPrivider/GetNotCountred.dart';
import 'package:http/http.dart' as http;
import 'Constants.dart';

class NotCounterd extends StatelessWidget {
  static const String id = 'notcountred_Screen';
  const NotCounterd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetNotCountred>(
        init:GetNotCountred() ,

        builder: (val)=>  Scaffold(
          appBar: AppBar(
            title: Text('عدادات غير مدخلة',),
          ),
          body: SingleChildScrollView(
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
                                        errorText: client.valid==1
                                            ? 'Wrong Input'
                                            : null,
                                      ),
                                      keyboardType: TextInputType.number,
                                    )),
                                Expanded(
                                  flex: 4,
                                  child: MaterialButton(
                                    onPressed: () async {


                                      if (val.checkifnum(client.cont.text
                                          .toString()) ==
                                          true ||
                                          int.parse(client.cont.text) <=
                                              int.parse(
                                                  client.LastCounter)) {
                                        val.setvalidatetrue(client.valid,1);
                                        print(client.valid);

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
          ),
        )

    );
  }
}
