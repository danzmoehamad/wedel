import 'package:get/get.dart';
import 'package:wedel/user/model/model_user.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_preferences.dart';

class PenggunaSekarang extends GetxController
{
                                    //Sesuai colom yang ditampilkan
  Rx<ModelUser> _penggunaSekarang = ModelUser(0,'','','','','').obs;

  ModelUser get user => _penggunaSekarang.value;

  getUserInfo() async
  {
    ModelUser? getUserInfoDariLocalStorage = await SavePengguna.membacaUser();
    _penggunaSekarang.value = getUserInfoDariLocalStorage!;
  }
}