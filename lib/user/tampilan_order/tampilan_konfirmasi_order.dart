import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedel/api_koneksi/api_koneksi.dart';
import 'package:wedel/user/controller/controller_order.dart';
//path galery photo
import 'package:path/path.dart' as path;
import 'package:wedel/user/fragment/fragment_dashboard.dart';
import 'package:wedel/user/model/model_order.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';

import 'package:http/http.dart' as http;

class TampilanKonfirmasiOrder extends StatelessWidget
{
  final List<int>? seleksiKeranjangId;
  final List<Map<String, dynamic>>? seleksiListKeranjangItemInfo;
  final double? total;

  final String? namaSystemDeliveryList;
  final String? namaSystemPembayaranList;

  final String? nomorTeleponController;
  final String? alamatPengirimController;
  final String? notaController;

  TampilanKonfirmasiOrder({
    this.seleksiKeranjangId,
    this.seleksiListKeranjangItemInfo,
    this.total,

    this.namaSystemDeliveryList,
    this.namaSystemPembayaranList,

    this.nomorTeleponController,
    this.alamatPengirimController,
    this.notaController,
});

  //Variabel upload image ke htdocs
  RxList<int> _seleksiImageByte = <int>[].obs;
  Uint8List get seleksiImageByte => Uint8List.fromList(_seleksiImageByte);

  RxString _seleksiNamaImage = "".obs;
  String get seleksiNamaImage => _seleksiNamaImage.value;

  //Image galery
  final ImagePicker _picker = ImagePicker();

  //User Online save order
  PenggunaSekarang penggunaSekarang = Get.put(PenggunaSekarang());



  setSeleksiImage(Uint8List seleksiImage)
  {
    _seleksiImageByte.value = seleksiImage;
  }

  setSeleksiNamaImage(String seleksiImageNama)
  {
    _seleksiNamaImage.value = seleksiImageNama;
  }


  pilihGambarDariGaleri() async
  {
    final gambarXFileDipilih = await _picker.pickImage(source: ImageSource.gallery);

    if(gambarXFileDipilih != null)
      {
        final imageBytes  = await gambarXFileDipilih.readAsBytes();
        setSeleksiImage(imageBytes);
        setSeleksiNamaImage(path.basename(gambarXFileDipilih.path));
      }
  }

  simpanInfoOrder() async
  {
    String seleksiItemString = seleksiListKeranjangItemInfo!.map((seleksiItem)=> jsonEncode(seleksiItem)).toList().join("||");

    ModelOrder modelOrder = ModelOrder(
      order_id: 1,
      user_id: penggunaSekarang.user.user_id,
      seleksiItem: seleksiItemString,
      systemDelivery: namaSystemDeliveryList,
      systemPembayaran: namaSystemPembayaranList,
      nota: notaController,
      total: total,
      gambar: DateTime.now().millisecondsSinceEpoch.toString() + "-" + seleksiNamaImage,
      status: "new",
      tanggalOrder: DateTime.now(),
      alamatUser: alamatPengirimController,
      nomorKontak: nomorTeleponController,

    );

    try
    {
      var res =  await http.post(
        Uri.parse(API.orderItem),
        body: modelOrder.toJson(base64Encode(seleksiImageByte)),
      );

      //Check
      if (res.statusCode == 200)
        {
          var responBodyOrder = jsonDecode(res.body);

          if(responBodyOrder["sukses"] == true)
            {
              // Fluttertoast.showToast(msg: "Transaksi berhasil");

              //hapus otomatis seleksi item dari user kerankjang pasca order
              seleksiKeranjangId!.forEach((seleksiKeranjangItemId)
              {
                hapusSeleksiItemDariKeranjangUser(seleksiKeranjangItemId);
              });


            }

          else
            {
              Fluttertoast.showToast(msg: "Error :: \nPesanan gagal, coba lagi");
            }
        }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error :" + errorMsg.toString());
    }
  }


  hapusSeleksiItemDariKeranjangUser(int keranjangID) async
  {
    try
    {
      var res = await http.post(
          Uri.parse(API.hapusSeleksiItemDariKeranjang),
          body:
          {
            "keranjang_id" : keranjangID.toString(),
          }
      );

      if(res.statusCode == 200)
      {
        var responBodyHapusKeranjang = jsonDecode(res.body);
        if(responBodyHapusKeranjang["sukses"] == true)
        {
          Fluttertoast.showToast(msg: "Order telah berhasil");
          Get.to(FragmentDashboard());

        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Tidak berstatus 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:" + errorMsg.toString());

      Fluttertoast.showToast(msg: errorMsg.toString());
    }
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
        body: Center(
          child: Column(
            //Center pass screen
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              //Image
              Image.asset(
                "images/transaksi.png",
                width: 160,
              ),
              const SizedBox(height: 4,),
              
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "MOHON LAMPIRKAN\nBukti transaksi - kwitansi - screenshot",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              //Seleksi Image Button
              Material(
                elevation: 8,
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {
                    pilihGambarDariGaleri();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text(
                      "Pilih Gambar",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              //tampilan seleksi image
              Obx(() => ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                  maxHeight: MediaQuery.of(context).size.width * 0.6,
                ),
                //Upload gambar ke local storage
                child: seleksiImageByte.length > 0
                    //if
                    ? Image.memory(seleksiImageByte, fit: BoxFit.contain,)
                    //else
                    : const Placeholder(color: Colors.white60),

                ),
              ),
              const SizedBox(height: 16),

              //Konfirmasi and Proses
              Obx(()=> Material(
                elevation: 8,
                  color: seleksiImageByte.length > 0
                      //if
                      ? Colors.white
                      //else
                      : Colors.white24,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {
                   if(seleksiImageByte.length > 0)
                     {
                       //Save info ke database
                       simpanInfoOrder();
                     }
                   else
                     {
                       Fluttertoast.showToast(msg: "Lampirkan bukti transaksi !");
                     }
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 12,
                    ),
                    child: Text(
                      "Konfirmasi",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
    );
  }
}
