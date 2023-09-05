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

class AdminGetSemuaOrder extends StatelessWidget
{
  final penggunaSekarang = Get.put(PenggunaSekarang());

  Future<List<ModelOrder>> getSemuaOrderList() async
  {
    List<ModelOrder>orderList = [];
    try
    {
      var res = await http.post(
          Uri.parse(API.adminGetSemuaOrder),
          body:
          {

          }
      );
      if (res.statusCode == 200)
      {
        var responBodyGetOrderData = jsonDecode(res.body);

        if(responBodyGetOrderData['sukses'] == true)
        {
          (responBodyGetOrderData['dataSemuaOrder'] as List).forEach((orderData)
          {
            orderList.add(ModelOrder.fromJson(orderData));
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

    return orderList;
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
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
            child: Row(
              //2 column left - right full
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                //Order Icon/Image
                // Orderku
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 8, 0),
                  child: Column(
                    children: [
                      Image.asset(
                        "images/order.png",
                        width: 140,
                      ),
                      Text(
                        "PROJEK ORDER",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Wedel Member",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
        future: getSemuaOrderList(),
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
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Center(
                    child: Text(
                      "Orderan Kosong, atau paket telah diterima !",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  // Center(
                  //   child: CircularProgressIndicator(),
                  // ),
                ],
              ),
            );
          }
        }
    );
  }
}
