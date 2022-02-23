
import 'package:flutter/material.dart';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled1/Constants.dart';
import 'package:untitled1/GetXPrivider/GetMain.dart';
class Setting_Secreen extends StatefulWidget {
  static const String id = 'Setting_Secreen';
  const Setting_Secreen({Key? key}) : super(key: key);

  @override
  _Setting_SecreenState createState() => _Setting_SecreenState();
}

class _Setting_SecreenState extends State<Setting_Secreen> {
  var username='';
  //BlueThermalPrinter printer = BlueThermalPrinter.instance;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  // List<BluetoothDevice> devices = [];
  // BluetoothDevice? selectedDevice;

  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _pressed = false;
  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      _devices.forEach((device) {
        items.add(DropdownMenuItem(
          child: Text(device.name.toString()),
          value: device,
        ));
      });
    }
    return items;
  }

  void _connect() {
    if (_device == null) {
      Fluttertoast.showToast(
          msg: 'No device selected.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      bluetooth.isConnected.then((isConnected) async {
        SharedPreferences _prefs = await SharedPreferences.getInstance();
        if (!isConnected!) {
          bluetooth.connect(_device!).catchError((error) {
            setState(() => _connected = false);
            Fluttertoast.showToast(
                msg: 'not connected"',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.grey,
                textColor: Colors.white,
                fontSize: 16.0);
          });
          setState(() => _connected = true);
          _prefs.setString('device', _device!.address.toString());
          Fluttertoast.showToast(
              msg: 'connected"',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    }
  }

  void _disconnect() {
    bluetooth.disconnect();
    setState(() => _connected = false);
    Fluttertoast.showToast(
        msg: 'disconnected"',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  Future<void> initPlatformState() async {
    List<BluetoothDevice> devices = [];

    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }

    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            _pressed = false;
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            _pressed = false;
          });
          break;
        default:
          print(state);
          break;
      }
    });

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });
  }




  // void getDevices() async{
  //   devices =await printer.getBondedDevices();
  //   setState(() {
  //
  //   });
  //
  // }
  void getusername() async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      username =_prefs.getString('user').toString();
    });
  }
  @override
  void initState() {
    initPlatformState();

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(NameofIshtirak,style: TextStyle(
          fontSize: 30,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),),

      ),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: Text(
              'Information',style: TextStyle(
            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 20,
              child: GetBuilder<GetMain>(
                init: GetMain(),
                builder: (val)=> Column(
                  children: [

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex:5,
                              child: Row(
                                children: [
                                  Icon(Icons.how_to_reg_rounded,size: 20,color: Colors.blue,),
                                  Text('Name:',style: TextStyle(
                                      fontSize: 20,color: Colors.blue
                                  ),)

                                ],
                              )
                          ),
                          Expanded(
                            flex: 5,
                            child:Text(
                              val.name,style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                            ),
                            ) ,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              flex:5,
                              child: Row(
                                children: [
                                  Icon(Icons.phone,size: 20,color: Colors.blue,),
                                  Text('user:',style: TextStyle(
                                      fontSize: 20,color: Colors.blue
                                  ),)



                                ],
                              )
                          ),
                          Expanded(
                            flex: 5,
                            child:Text(
                              val.user,style: TextStyle(
                              fontSize: 20,
                              color: Colors.red,
                            ),
                            ) ,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MaterialButton(
                        color: Colors.blue,
                        onPressed: (){

                        },
                        child: Text('Change Password',style: TextStyle(
                            fontSize: 20
                        ),),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child:Text('Printer Setup') ,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
                elevation: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Device:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Expanded(
                          child: DropdownButton(
                            items: _getDeviceItems(),
                            onChanged: (value) => setState(() => _device = value as BluetoothDevice?),
                            value: _device,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.brown),
                          onPressed: () {
                            initPlatformState();
                          },
                          child: Text(
                            'Refresh',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: _connected ? Colors.red : Colors.green),
                          onPressed: _connected ? _disconnect : _connect,
                          child: Text(
                            _connected ? 'Disconnect' : 'Connect',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),


                    // Center(
                    //   child: DropdownButton<BluetoothDevice>(
                    //     hint: const Text('select Thermal Printer',style: TextStyle(
                    //       color: Colors.black,
                    //       fontSize: 20
                    //
                    //     ),),
                    //
                    //     value: _device,
                    //     items:_devices.map((e) => DropdownMenuItem
                    //       (child: Text(e.name!),
                    //       value: e,
                    //     ),
                    //     ).toList(),
                    //     onChanged: (device) async {
                    //
                    //       setState(() {
                    //         _device = device;
                    //       });
                    //
                    //     },
                    //
                    //   ),
                    // ),
                    // Center(
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: ElevatedButton(onPressed: () async{
                    //
                    //
                    //
                    //         },
                    //             child: Text("Connect",style: TextStyle(
                    //               fontSize: 20,
                    //               color: Colors.black
                    //             ),)
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: const EdgeInsets.all(8.0),
                    //         child: ElevatedButton(onPressed: () async{
                    //           if(selectedDevice == null){
                    //             Fluttertoast.showToast(
                    //                 msg: "no printer",
                    //                 toastLength: Toast.LENGTH_SHORT,
                    //                 gravity: ToastGravity.BOTTOM,
                    //                 timeInSecForIosWeb: 1,
                    //                 backgroundColor: Colors.grey,
                    //                 textColor: Colors.white,
                    //                 fontSize: 16.0);
                    //           }
                    //           else{
                    //             await printer.disconnect();
                    //             if(printer.isConnected == false){
                    //               Fluttertoast.showToast(
                    //                   msg: "Disconnected",
                    //                   toastLength: Toast.LENGTH_SHORT,
                    //                   gravity: ToastGravity.BOTTOM,
                    //                   timeInSecForIosWeb: 1,
                    //                   backgroundColor: Colors.grey,
                    //                   textColor: Colors.white,
                    //                   fontSize: 16.0);
                    //
                    //             }
                    //           }
                    //
                    //
                    //         },
                    //             child: Text("Disconnect",style: TextStyle(
                    //                 fontSize: 20,
                    //                 color: Colors.black
                    //             ),)
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                )
            ),
          ),


        ],
      ),

    );
  }
}


