import 'package:get/get.dart';
import 'package:wedel/user/model/model_keranjang.dart';

class ControllerListKeranjang extends GetxController
{
   RxList<ModelKeranjang> _keranjangList = <ModelKeranjang>[].obs;
   RxList<int> _seleksiItemList = <int>[].obs;
   RxBool _seleksiSemuaItem = false.obs;
   RxDouble _jumlah = 0.0.obs;

   List<ModelKeranjang> get keranjangList => _keranjangList.value;
   List<int> get seleksiItemList => _seleksiItemList.value;
   bool get seleksiSemuaItem => _seleksiSemuaItem.value;
   double get jumlah => _jumlah.value;

   setList(List<ModelKeranjang> List)
   {
      _keranjangList.value = List;
   }

   tambahSeleksiItem(int seleksiItemKeranjangID)
   {
      _seleksiItemList.value.add(seleksiItemKeranjangID);
      update();
   }

   hapusSeleksiItem(int seleksiItemKeranjangID)
   {
      _seleksiItemList.value.remove(seleksiItemKeranjangID);
      update();
   }

   setSeleksiSemuaItem()
   {
                                 //True
      _seleksiSemuaItem.value = !_seleksiSemuaItem.value;
   }

   hapusSemuaSeleksiItem()
   {
      _seleksiItemList.value.clear();
      update();
   }

   setJumlah(double totalKeseluruhan)
   {
      _jumlah.value = totalKeseluruhan;
   }

}