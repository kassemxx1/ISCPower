import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled1/GetXPrivider/GetSplash.dart';

class Splash_Screen extends StatelessWidget {
  static const String id = 'Splash_Screen';
  const Splash_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GetSplash>(
      init: GetSplash(),
      initState:(value){
      },
      builder: (val)=> Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('                                ISC-Power',
                style: TextStyle(
                  fontSize: 30,
                  decoration: TextDecoration.underline,
                ),
              ),
              Text(
                '                                          APP',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        )
      )
    );
  }
}
