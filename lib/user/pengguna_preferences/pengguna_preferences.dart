import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:wedel/user/model/model_user.dart';

class SavePengguna
{
  //Mengingat Info User
  static Future<void> SavePenggunaUser(ModelUser userInfo) async
  {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String userJsonData = jsonEncode(userInfo.toJson());
    await preferences.setString("penggunaSekarang", userJsonData);

  }

  //Membaca User Info
    static Future<ModelUser?> membacaUser() async
    {
      ModelUser? infoPenggunaUser;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String? infoUser = preferences.getString("penggunaSekarang");
      if(infoUser != null)
        {
          Map<String, dynamic> petaDataUser = jsonDecode(infoUser);
          infoPenggunaUser = ModelUser.fromJson(petaDataUser);
        }
      return infoPenggunaUser;
    }
    //Implementasi logout
    static Future<void> hapusInfoUser() async
    {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.remove("penggunaSekarang");
    }
}