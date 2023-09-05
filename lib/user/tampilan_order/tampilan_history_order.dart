import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:wedel/user/model/model_order.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';
import 'package:wedel/user/tampilan_order/tampilan_detail_order.dart';
import 'package:wedel/widget/title_text.dart';
import 'package:http/http.dart' as http;

import '../../api_koneksi/api_koneksi.dart';

class TampilanHistoryOrder extends StatelessWidget
{
  final penggunaSekarang = Get.put(PenggunaSekarang());

  //Copas fragment_favorite.dart
  Future<List<ModelOrder>> getUserOrderList() async
  {
    List<ModelOrder>orderUseritem = [];
    try
    {
      var res = await http.post(
          Uri.parse(API.readHistoryOrder),
          body:
          {
            "penggunaOnlineUserID":penggunaSekarang.user.user_id.toString(),
          }
      );
      if (res.statusCode == 200)
      {
        var responBodyGetOrderUser = jsonDecode(res.body);

        if(responBodyGetOrderUser['sukses'] == true)
        {
          (responBodyGetOrderUser['dataOrderUser'] as List).forEach((eachPenggunaFavoriteUserItem)
          {
            orderUseritem.add(ModelOrder.fromJson(eachPenggunaFavoriteUserItem));
          });
        }
        // else
        // {
        // Fluttertoast.showToast(msg: "Keranjang kosong");
        // }
        // controllerListKeranjang.setList(daftarKeranjangUser);
      }
      else
      {
        Fluttertoast.showToast(msg: "Tidak berstatus 200");
      }
    }
    catch(errorMsg)
    {
      Fluttertoast.showToast(msg: "Error::" + errorMsg.toString());
    }

    return orderUseritem;
  }

  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //My Order image  -> history
          //My Order Title  -> title
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 34, 8, 0),
              child:
              //Order Icon/Image
              // Orderku
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      "images/history.png",
                      width: 140,
                    ),
                  ),
                  Text(
                    "History",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 23.0),
              child: Text(
                "Pesanan yang telah diterima",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),

          //Tampilan Order
          Expanded(
            child: tampilanOrderList(context),
          ),
        ],
      ),
    );
  }

  Widget tampilanOrderList(context)
  {
    return FutureBuilder(
        future: getUserOrderList(),
        builder: (context, AsyncSnapshot<List<ModelOrder>> cuplikanData)
        {
          //Membutuhkan Akses Internet
          if(cuplikanData.connectionState == ConnectionState.waiting)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "On proses...",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }

          if(cuplikanData.data == null)
          {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                Center(
                  child: Text(
                    "Order produk tidak ditemukan..",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            );
          }

          if(cuplikanData.data!.length > 0)
          {
            List<ModelOrder> orderListInfo = cuplikanData.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              separatorBuilder: (context, index)
              {
                return const Divider(
                  height: 1,
                  thickness: 1,

                );
              },
              itemCount: orderListInfo.length,
              itemBuilder: (context, index)
              {
                ModelOrder orderData = orderListInfo[index];

                return Card(
                  color: Colors.white24,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: ListTile(
                      onTap: ()
                      {
                        Get.to(TampilanDetailOrder(
                          klikOrderInfo: orderData,
                        ));
                      },
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Order ID #" + orderData.order_id.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Total : Rp." + orderData.total.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          //tanggal order
                          //waktu
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              //Tanggal
                              Text(
                                DateFormat(
                                    "dd MMMM, yyyy"
                                ).format(orderData.tanggalOrder!),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4,),
                              //Waktu
                              Text(
                                DateFormat(
                                    "hh:mm a"
                                ).format(orderData.tanggalOrder!),
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),

                            ],
                          ),

                          const  SizedBox(height: 6),

                          Icon(
                            Icons.navigate_next,
                            color: Colors.white,

                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          else
          {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "Cek koneksi Internet, atau history kamu kosong !",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              ),
            );
          }
        }
    );
  }
}
