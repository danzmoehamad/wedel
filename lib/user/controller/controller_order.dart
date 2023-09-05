import 'package:get/get.dart';

class ControllerOrder extends GetxController
{
  RxString _systemDelivery = "FedEx".obs;
  RxString _systemPembayaran = "Apple Pay".obs;

  String get sysDelivery => _systemDelivery.value;
  String get sysPembayaran => _systemPembayaran.value;

  setSystemDelivery(String newSystemDelivery)
  {
    _systemDelivery.value = newSystemDelivery;
  }

  setSystemPembayaran(String newSystemPembayaran)
  {
    _systemPembayaran.value = newSystemPembayaran;
  }

}