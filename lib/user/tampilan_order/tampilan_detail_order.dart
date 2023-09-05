import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wedel/api_koneksi/api_koneksi.dart';
import 'package:wedel/user/fragment/fragment_dashboard.dart';
import 'package:wedel/user/model/model_order.dart';
import 'package:http/http.dart' as http;

class TampilanDetailOrder extends StatefulWidget
{
  final ModelOrder? klikOrderInfo;
  //Tampilan detail order klik from fragment_order.dart
  TampilanDetailOrder({this.klikOrderInfo});


  @override
  State<TampilanDetailOrder> createState() => _TampilanDetailOrderState();
}



class _TampilanDetailOrderState extends State<TampilanDetailOrder>
{
  //Inisial Paket Diterima
  RxString _status = "new".obs;
  String get status => _status.value;

  updateStatusPaketUI(String paketDiterima)
  {
    _status.value = paketDiterima;
  }

  //Show konfirmasi button paket
  showDialogKonfirmasiPaket() async
  {
    if(widget.klikOrderInfo!.status == "new")
      {
        var response = await Get.dialog(
          AlertDialog(
            backgroundColor: Colors.black,
              title: const Text(
                "Konfirmasi",
                  style: const TextStyle(
                    color: Colors.grey,

                  ),
              ),
              content: const Text(
                "Sudah menerima paket ?",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: ()
                  {
                    Get.back();
                  },
                  child: const Text(
                    "Belum",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: ()
                  {
                    Get.back(result: "yaKonfirmasi");
                  },
                  child: const Text(
                    "Sudah",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );

        //konfirmasi yaKonfirmasi
        if(response == "yaKonfirmasi")
          {
            updateStatusValueDiDatabase();
          }
      }
    return Get.to(FragmentDashboard());

  }

  updateStatusValueDiDatabase() async
  {
    try
    {
      var response =  await http.post(
        Uri.parse(API.updateStatusPaket),
        body:
          {
            "order_id" : widget.klikOrderInfo!.order_id.toString(),

          }
      );

      if(response.statusCode == 200)
      {
        var responseBodyUpdateStatus = jsonDecode(response.body);
        //check
        if(responseBodyUpdateStatus["sukses"] == true)
        {
          updateStatusPaketUI("sampai");
        }
      }
    }
    catch(errorMsg)
    {
      print(errorMsg.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    updateStatusPaketUI(widget.klikOrderInfo!.status.toString());
  }
  


  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          DateFormat("dd MMMM, yyyy - hh:mm a").format(widget.klikOrderInfo!.tanggalOrder!),
          style: const TextStyle(
            fontSize: 14,
          ),
        ),

        //Membuat Button Paket diterima
        actions: [
          Padding(
            padding: EdgeInsets.fromLTRB(8, 12, 16, 12),
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              child: InkWell(
                onTap: ()
                {
                  //kondisi
                  if(status == "new")
                    {
                      showDialogKonfirmasiPaket();
                    }

                },
                borderRadius: BorderRadius.circular(30),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Row(
                    children: [
                      const Text(
                        "Terima",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Obx(()=>
                      status == "new"
                          ? Icon(Icons.help_outline, color: Colors.black)
                          : Icon(Icons.check_circle, color:Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //Tampilan Item pasca klik order!
              tampilanKlikOrderItem(),

              const SizedBox(height: 16),
              //Nomor Telepon !
              tampilTitleText("Nomor Telepon :"),
              const SizedBox(height: 8),
              tampilContentText(widget.klikOrderInfo!.nomorKontak!),

              const SizedBox(height: 16),
              //alamat !
              tampilTitleText("Alamat :"),
              const SizedBox(height: 8),
              tampilContentText(widget.klikOrderInfo!.alamatUser!),

              const SizedBox(height: 16),
              //Antar Barang
              tampilTitleText("Delivery :"),
              const SizedBox(height: 8),
              tampilContentText(widget.klikOrderInfo!.systemDelivery!),

              const SizedBox(height: 16),
              //System Pembayaran
              tampilTitleText("Pembayaran :"),
              const SizedBox(height: 8),
              tampilContentText(widget.klikOrderInfo!.systemPembayaran!),

              const SizedBox(height: 16),
              //Nota
              tampilTitleText("Keterangan :"),
              const SizedBox(height: 8),
              tampilContentText(widget.klikOrderInfo!.nota!),

              const SizedBox(height: 16),
              //Total
              tampilTitleText("Total Pembayaran :"),
              const SizedBox(height: 8),
              tampilContentText(widget.klikOrderInfo!.total.toString()),

              const SizedBox(height: 16),
              //ScrrenShoot
              tampilTitleText("Bukti Transaksi :"),
              const SizedBox(height: 8),
              FadeInImage(
                width: MediaQuery.of(context).size.width * 0.8,
                fit: BoxFit.fitWidth,
                placeholder: AssetImage("images/placeholder.png"),
                image: NetworkImage(
                  API.hostImage + widget.klikOrderInfo!.gambar!,
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
            ],
          ),
        ),
      ),
    );
  }

  Widget tampilTitleText(String titleText)
  {
    return Text(
      titleText,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey,
      ),
    );
  }

  Widget tampilContentText(String contentText)
  {
    return Text(
      contentText,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white38,
      ),
    );
  }

  //Copas tampilan_item_order.dart
  Widget tampilanKlikOrderItem()
  {
                        //Database Tabel
    List<String> klikOrderItemInfo = widget.klikOrderInfo!.seleksiItem!.split("||");

    return Column(
      children: List.generate(klikOrderItemInfo.length, (index)
      {
        Map<String, dynamic> infoItem = jsonDecode(klikOrderItemInfo[index]);

        return Container(
          margin: EdgeInsets.fromLTRB(
            16, //top
            index == 0 ? 16 : 8,//from top, right
            16,//from right
            index == klikOrderItemInfo.length - 1 ? 16 : 8,
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
                    infoItem["gambar"],
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
                        infoItem["nama"],
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
                        infoItem['warna_item'].replaceAll("[", "").replaceAll("]", ""),
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
                        "Rp." + infoItem['total'].toString(),
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
                        infoItem["harga"].toString() + " x "
                            + infoItem["kuantitas"].toString()
                            + " = " + infoItem["total"].toString(),
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
                  "Q:" + infoItem["kuantitas"].toString(),
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
