import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/GetXPrivider/GETPaid.dart';

class Paid_Screen extends StatelessWidget {
  static const String id = 'Paid_Screen';
  const Paid_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetPaid>(
        init:GetPaid() ,

        builder: (val)=>
    Scaffold(
      appBar: AppBar(
        title: Text('غير مدفوع'),
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: [
                DataColumn(label: Padding(
                  padding: const EdgeInsets.all(8.0),

                ))
              ],
              rows:
                val.paid.map((paidclient) =>
                DataRow(
                  cells: [
                    DataCell(
                      Container(
                        width: MediaQuery.of(context).size.width -5,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                                child: Text(
                              paidclient.clientName,style: TextStyle(
                              fontSize: 14
                            ),
                            )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  paidclient.Narration,style: TextStyle(
                                    fontSize: 14
                                ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  paidclient.fctnbr,style: TextStyle(
                                    fontSize: 14
                                ),
                                )),
                            Expanded(
                                flex: 1,
                                child: Text(
                                  paidclient.balance,style: TextStyle(
                                    fontSize: 14
                                ),
                                )),

                          ],
                        ),
                      )
                    )
                  ]
                )
                ).toList(),

            ),
          )
        ],
      ),
    )
    );
  }
}
class paidclient {
  String clientName;
  String Narration;
  String fctnbr;
  String balance;
  paidclient(this.clientName,this.Narration,this.fctnbr,this.balance);
}