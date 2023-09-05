import 'package:get/get.dart';

class ControllerDetailItem extends GetxController
{
  RxInt _kuantitasItem = 1.obs;
  RxInt _ukuranItem = 0.obs;
  RxInt _warnaItem = 0.obs;
  RxBool _terFavorite = false.obs;

  int get kuantitas => _kuantitasItem.value;//3
  int get ukuran => _ukuranItem.value;
  int get warna => _warnaItem.value;
  bool get favorit => _terFavorite.value;


  setKuantitasItem(int kuantitasItem)
  {
    //3
    _kuantitasItem.value = kuantitasItem;
  }
  setUkuranItem(int ukuranItem)
  {
    _ukuranItem.value = ukuranItem;
  }
  setWarnaItem(int warnaItem)
  {
    _warnaItem.value = warnaItem;
  }
  setTerFavorite(bool terFavorite)
  {
    _terFavorite.value = terFavorite;
  }
}