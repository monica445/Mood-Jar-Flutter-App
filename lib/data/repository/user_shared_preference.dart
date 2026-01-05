import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreference {
  static const String userName = "userName";

  
  static Future<void> saveUserName(String name) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString(userName, name);
    print("user name has been saved");
    final savedUserName = UserSharedPreference.getUserName();
    print("saved user name is $savedUserName");
  }

  static Future<String?> getUserName() async{
    final preference = await SharedPreferences.getInstance();
    return preference.getString(userName);
  }

  static Future<void> removeUserName() async{
    final preference = await SharedPreferences.getInstance();
    await preference.remove('username'); 
  }
}