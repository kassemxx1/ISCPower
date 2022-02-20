import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled1/GetXPrivider/GetLogin.dart';
import 'package:untitled1/Login_Screen.dart';

class GetSplash extends GetLogin{
  @override
  void onInit() async{
    getUDID();
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // TODO: implement onInit
    super.onInit();
    if(_prefs.getString('user')==null){
      Get.offAll(Login_Screen());
    }
    else{
      Login(_prefs.getString('user').toString(),_prefs.getString('pass').toString(),_prefs.getString('user')=='kassem123'?'APP1': _prefs.getString('pass').toString());
    }
  }
  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
}
