import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wedel/user/controller/controller_order.dart';
import 'package:wedel/user/tampilan_order/tampilan_konfirmasi_order.dart';

class TampilanItemOrder extends StatelessWidget
{
  //Memanggil Order Bottom di tampilan_list_keranjang.dart
  final List<Map<String, dynamic>>? seleksiListKeranjangItemInfo;
  final double? total;
  final List<int>? seleksiKeranjangId;

  ControllerOrder controllerOrder = Get.put(ControllerOrder());

  //Delivery
  List<String> namaSystemDeliveryList = ["FedEx", "DHL", "Cileuleuy Order"];

  //Pembayaran
  List<String> namaSystemPembayaranList = ["Apple Pay", "Goggle Pay", "Transfer"];

  TextEditingController nomorTeleponController = TextEditingController();
  TextEditingController alamatPengirimController = TextEditingController();
  TextEditingController notaController = TextEditingController();

  TampilanItemOrder({
  this.seleksiListKeranjangItemInfo,
  this.total,
  this.seleksiKeranjangId,
  });
  //Memanggil button order di tampilan_list_keranjang.dart

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Order Sekarang"
        ),
        titleSpacing: 0,
      ),

      body: ListView(
        children: [

          //Menampilkan Seleksi item dari list keranjang
          menampilkanSeleksiItemDarikeranjangUser(),

          const SizedBox(height: 30,),


          //System Delivery
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "System Delivery :",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: namaSystemDeliveryList.map((namaSystemDelivery)
              {
                return Obx(() =>
                    RadioListTile<String>(
                      tileColor: Colors.white30,
                      dense: true,
                      activeColor: Colors.white,
                      title: Text(
                        namaSystemDelivery,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      value: namaSystemDelivery,
                      groupValue: controllerOrder.sysDelivery,
                      onChanged: (newSystemDeliveryValue)
                      {
                        controllerOrder.setSystemDelivery(newSystemDeliveryValue!);
                      },
                    )
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 10,),


          //System Pembayaran
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(

              //Left text
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "System Pembayaran :",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 2,),

                Text(
                  "Nomor Inventaris Perusahaan / ID : \n080-989-080-9",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: namaSystemPembayaranList.map((namaSystemPembayaranList)
              {
                return Obx(() =>
                    RadioListTile<String>(
                      tileColor: Colors.white30,
                      dense: true,
                      activeColor: Colors.white,
                      title: Text(
                        namaSystemPembayaranList,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      value: namaSystemPembayaranList,
                      groupValue: controllerOrder.sysPembayaran,
                      onChanged: (newSystemPembayaranValue)
                      {
                        controllerOrder.setSystemPembayaran(newSystemPembayaranValue!);
                      },
                    )
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16,),
          //Nomor Telepon
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Nomor Telepon:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Form nomor telepon
          Padding(              //left, top, right, bottom
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.white54,
              ),
              controller: nomorTeleponController,
              decoration: InputDecoration(
                hintText: 'nomor kontak',
                hintStyle: const TextStyle(
                  color: Colors.white24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),

              ),
            ),
          ),

          const SizedBox(height: 7,),
          //Alamat
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Alamat pengirim:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Form alamat
          Padding(              //left, top, right, bottom
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.white54,
              ),
              controller: alamatPengirimController,
              decoration: InputDecoration(
                hintText: 'alamat pengirim',
                hintStyle: const TextStyle(
                  color: Colors.white24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),

              ),
            ),
          ),
          const SizedBox(height: 7,),

          //Nota
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Nota:",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          //Form nota
          Padding(              //left, top, right, bottom
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: TextField(
              style: const TextStyle(
                color: Colors.white54,
              ),
              controller: notaController,
              decoration: InputDecoration(
                hintText: 'nota penjual',
                hintStyle: const TextStyle(
                  color: Colors.white24,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Colors.white24,
                    width: 1,
                  ),
                ),

              ),
            ),
          ),

          const SizedBox(height: 20),
          //Button Pembayaran
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {
                  if(nomorTeleponController.text.isNotEmpty && alamatPengirimController.text.isNotEmpty)
                    {
                      Get.to(TampilanKonfirmasiOrder(
                        //List
                        seleksiKeranjangId:seleksiKeranjangId,
                        seleksiListKeranjangItemInfo:seleksiListKeranjangItemInfo,
                        total:total,

                        //Controller_order.dart
                        namaSystemDeliveryList:controllerOrder.sysDelivery,
                        namaSystemPembayaranList:controllerOrder.sysPembayaran,

                        //Database
                        nomorTeleponController:nomorTeleponController.text,
                        alamatPengirimController:alamatPengirimController.text,
                        notaController:notaController.text,
                      ));
                    }
                  else
                    {
                      Fluttertoast.showToast(msg: "silahkan lengkapi formulirnya !");
                    }
                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                    Text(
                      "Rp." + total!.toStringAsFixed(2),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                     ),

                      Spacer(),
                      const Text(
                        "Total Pembayaran",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  //Display Info Item
  menampilkanSeleksiItemDarikeranjangUser()
  {
    return Column(
      children: List.generate(seleksiListKeranjangItemInfo!.length, (index)
      {
        Map<String, dynamic> seleksiItem = seleksiListKeranjangItemInfo![index];

        return Container(
          margin: EdgeInsets.fromLTRB(
            16, //top
            index == 0 ? 16 : 8,//from top, right
            16,//from right
            index == seleksiListKeranjangItemInfo!.length - 1 ? 16 : 8,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: Colors.white,
              width: 0,
            ),
            color: Colors.black,
          ),
          child: Row(
            children: [

              //Menampilkan Gambar
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(0),
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)
                ),
                child: FadeInImage(
                  height: 150,
                  width: 130,
                  fit: BoxFit.cover,
                  placeholder: AssetImage("images/placeholder.png"),
                  image: NetworkImage(
                    seleksiItem["gambar"],
                  ),
                  imageErrorBuilder: (context, error, stackTraceError)
                  {
                    return Center(
                      child : Icon(
                        Icons.broken_image_outlined,
                      ),
                    );
                  },
                ),
              ),

              //nama
              //ukuran
              //harga
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //nama
                      Text(
                        seleksiItem["nama"],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),
                      // database keranjang
                      //warna_item
                      Text(
                        //Menghilangkan [] di database
                        seleksiItem['warna_item'].replaceAll("[", "").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),

                      //Database tabel_item
                      //harga
                      Text(
                        //Menghilangkan [] di database
                        "Rp." + seleksiItem['total'].toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      //
                      const SizedBox(height: 3),
                      Text(
                        seleksiItem["harga"].toString() + " x "
                            + seleksiItem["kuantitas"].toString()
                            + " = " + seleksiItem["total"].toString(),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //Kuantitas
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Q:" + seleksiItem["kuantitas"].toString(),
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),

            ],
          ),
        );
      }),
    );
  }
}
