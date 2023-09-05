import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wedel/user/controller/controller_list_keranjang.dart';
import 'package:wedel/user/model/model_baju.dart';
import 'package:wedel/user/model/model_keranjang.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/tampilan_item/tampilan_detail_item.dart';
import 'package:wedel/user/tampilan_order/tampilan_item_order.dart';

import '../../api_koneksi/api_koneksi.dart';

class TampilanListKeranjang extends StatefulWidget
{
  @override
  State<TampilanListKeranjang> createState() => _TampilanListKeranjangState();
}

class _TampilanListKeranjangState extends State<TampilanListKeranjang>
{
  final penggunaSekarang= Get.put(PenggunaSekarang());
  final controllerListKeranjang = Get.put(ControllerListKeranjang());

  getKeranjangUserList() async
  {
    List<ModelKeranjang> daftarKeranjangUser = [];
    try
    {
      var res = await http.post(
        Uri.parse(API.getKeranjangList),
        body:
          {
            "penggunaOnlineUserID":penggunaSekarang.user.user_id.toString(),
          }
      );
      if (res.statusCode == 200)
      {
        var responBodyGetKeranjangPenggunaUser = jsonDecode(res.body);

        if(responBodyGetKeranjangPenggunaUser['sukses'] == true)
          {
            (responBodyGetKeranjangPenggunaUser['dataKeranjangUser'] as List).forEach((eachPenggunaKeranjangUserItem)
                {
                  daftarKeranjangUser.add(ModelKeranjang.fromJson(eachPenggunaKeranjangUserItem));
                });
          }
        else
        {
          Fluttertoast.showToast(msg: "Keranjang kosong");
        }
        controllerListKeranjang.setList(daftarKeranjangUser);
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
    jumlahKalkulasiItemKeranjang();
  }

  jumlahKalkulasiItemKeranjang()
  {
    controllerListKeranjang.setJumlah(0);
    if(controllerListKeranjang.seleksiItemList.length > 0)
      {
        controllerListKeranjang.keranjangList.forEach((itemDiKeranjang)
        {
          if(controllerListKeranjang.seleksiItemList.contains(itemDiKeranjang.keranjang_id))
            {
              double jumlahTotalItemSekarang = (itemDiKeranjang.harga!) * (double.parse(itemDiKeranjang.kuantitas.toString()));

              // controllerListKeranjang.setJumlah(jumlahTotalItemSekarang);
              controllerListKeranjang.setJumlah(controllerListKeranjang.jumlah + jumlahTotalItemSekarang);
            }
        });
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
              getKeranjangUserList();
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

  //Implementasi Update Kuantitas/produk
  updateKuantitasDiKeranjang(int keranjangID, int newKuantitas) async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.updateItemdiKeranjang),
        body:
          {
            "keranjang_id": keranjangID.toString(),
            "kuantitas" : newKuantitas.toString(),
          }
      );
      if(res.statusCode == 200)
      {
        var responBodyUpdateKeranjang = jsonDecode(res.body);
        if(responBodyUpdateKeranjang["sukses"] == true)
        {
          getKeranjangUserList();
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Tidak berstatus 200");
      }
    }
    catch (errorMsg)
    {
      print("Error: " + errorMsg.toString());
      
      Fluttertoast.showToast(msg: "Error : " + errorMsg.toString());
    }
  }

  //Memanggil Order Bottom Keranjang List
  List<Map<String, dynamic>> getSeleksiKeranjangItemInformasi()
  {
    List<Map<String, dynamic>> seleksiKeranjangItemInformasi = [];

    if(controllerListKeranjang.seleksiItemList.length > 0)
      {
        controllerListKeranjang.keranjangList.forEach((seleksiKeranjangListItem)
        {
          if(controllerListKeranjang.seleksiItemList.contains(seleksiKeranjangListItem.keranjang_id))
            {
              Map<String, dynamic> informasiItem =
              {
                //  Database table_item
                "item_id" : seleksiKeranjangListItem.item_id,
                "nama"    : seleksiKeranjangListItem.nama,
                "gambar"  : seleksiKeranjangListItem.gambar,
                "kuantitas": seleksiKeranjangListItem.kuantitas,
                "total" : seleksiKeranjangListItem.harga! * seleksiKeranjangListItem.kuantitas!,
                "harga"    : seleksiKeranjangListItem.harga!,

                //Database keranjang
                "warna_item"   : seleksiKeranjangListItem.warna_item,
                "ukuran_item"  : seleksiKeranjangListItem.ukuran_item,
              };

              seleksiKeranjangItemInformasi.add(informasiItem);
            }
        });
      }
    return seleksiKeranjangItemInformasi;
  }


  //Memanggil getKeranjangUserList
  @override
  void initState() {
    super.initState();
    getKeranjangUserList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Membuat app bar dan icon hapus, check box
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Keranjang",
        ),
        actions: [
          //Selekssi semua item
          Obx(() =>
              IconButton(
                onPressed: ()
                {
                  controllerListKeranjang.setSeleksiSemuaItem();
                  controllerListKeranjang.hapusSemuaSeleksiItem();

                  if(controllerListKeranjang.seleksiSemuaItem)
                    {
                      controllerListKeranjang.keranjangList.forEach((itemSaatIni)
                      {
                        controllerListKeranjang.tambahSeleksiItem(itemSaatIni.keranjang_id!);
                      });
                    }

                  jumlahKalkulasiItemKeranjang();
                },
                icon : Icon(
                  controllerListKeranjang.seleksiSemuaItem
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  color: controllerListKeranjang.seleksiSemuaItem
                    // ? berarti true
                      ? Colors.white
                      : Colors.grey,
                ),
              ),
          ),
          //ke hapus semua item
          GetBuilder(
            init: ControllerListKeranjang(),
            builder: (c)
            {
              if(controllerListKeranjang.seleksiItemList.length > 0)
                {
                  return IconButton(
                    onPressed: () async
                    {
                      var responDariDialogBox = await Get.dialog(
                        AlertDialog(
                          backgroundColor: Colors.grey,
                          title: const Text("Hapus"),
                          content: const Text("Yakin lur ?"),
                          actions:
                          [
                            TextButton(
                              onPressed: ()
                              {
                                Get.back();
                              },
                              child: const Text(
                                "Tidak",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: ()
                              {
                                Get.back(result: "yaHapus");
                              },
                              child: const Text(
                                "Iya",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      if(responDariDialogBox == "yaHapus")
                        {
                          controllerListKeranjang.seleksiItemList.forEach((seleksiKeranjangUserItemID)
                          {
                            //Hapus seleksi item sekarang
                            hapusSeleksiItemDariKeranjangUser(seleksiKeranjangUserItemID);


                          });
                        }
                      jumlahKalkulasiItemKeranjang();
                    },
                    icon: const Icon(
                      Icons.delete_sweep,
                      size: 26,
                      color : Colors.redAccent,
                    ),
                  );
                }
              else
                {
                  return Container();
                }
            }
          ),
        ],
      ),
      body: Obx(()=>
          controllerListKeranjang.keranjangList.length > 0
              ? ListView.builder(
            itemCount: controllerListKeranjang.keranjangList.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index)
            {
              ModelKeranjang keranjangModel = controllerListKeranjang.keranjangList[index];

              ModelBaju bajuModel = ModelBaju(
                item_id: keranjangModel.item_id,
                warna: keranjangModel.warna,
                gambar: keranjangModel.gambar,
                nama: keranjangModel.nama,
                harga: keranjangModel.harga,
                rating: keranjangModel.rating,
                ukuran: keranjangModel.ukuran,
                deskripsi: keranjangModel.deskripsi,
                tags: keranjangModel.tags,
              );
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    //CheckBox Item
                    GetBuilder(
                      init: ControllerListKeranjang(),
                      builder: (c)
                      {
                        return IconButton(
                          onPressed: ()
                          {
                            if (controllerListKeranjang.seleksiItemList.contains(keranjangModel.keranjang_id))
                              {
                                //
                                controllerListKeranjang.hapusSeleksiItem(keranjangModel.keranjang_id!);
                              }
                            else
                              {
                                controllerListKeranjang.tambahSeleksiItem(keranjangModel.keranjang_id!);
                              }

                            jumlahKalkulasiItemKeranjang();
                          },
                          icon : Icon(
                            controllerListKeranjang.seleksiItemList.contains(keranjangModel.keranjang_id)
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: controllerListKeranjang.seleksiSemuaItem
                                ? Colors.white
                                :Colors.grey,
                          ),
                        );
                      },
                    ),

                    //Nama
                    //warna, ukuran, harga
                    //+ -
                    Expanded(
                        child: GestureDetector(
                          onTap: ()
                          {
                            Get.to(TampilanDetailItem(infoItem: bajuModel,));
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(
                              0,
                              index == 0 ? 16 : 8,
                              16,
                              //bottom
                              index == controllerListKeranjang.keranjangList.length - 1 ? 16 : 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black,
                              boxShadow:
                              const [
                                BoxShadow(
                                  offset: Offset(0, 0),
                                  blurRadius: 6,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                            child: Row(
                              children: [

                                //Nama
                                //warna, ukuran, harga
                                //+ -
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        //Nama
                                        Text(
                                          bajuModel.nama.toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        const SizedBox(height: 20,),

                                        //Warna
                                        Row(
                                          children: [

                                            // warna ukuran
                                            Expanded(
                                              child: Text(
                                                "Warna: ${keranjangModel.warna_item!.replaceAll('[', '').replaceAll(']', '')}"
                                                + "\n" +
                                                "Ukuran: ${keranjangModel.ukuran_item!.replaceAll('[', '').replaceAll(']', '')}",
                                                maxLines: 3,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),

                                            //harga
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 12,
                                                right: 12.0,
                                              ),
                                              child: Text(
                                                "Rp." + bajuModel.harga.toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 20,),

                                        //+ -
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            // - kurangi kuantitas
                                            IconButton(
                                              onPressed: ()
                                              {
                                                //Update
                                                if (keranjangModel.kuantitas! - 1 >= 1)
                                                {
                                                  updateKuantitasDiKeranjang(
                                                    keranjangModel.keranjang_id!,
                                                    keranjangModel.kuantitas! - 1,
                                                  );
                                                }
                                              },
                                              icon: Icon(
                                                  Icons.remove_circle_outline,
                                                  color: Colors.grey,
                                                  size: 25,
                                              ),
                                            ),

                                            // const SizedBox(width: 2,),

                                            Text(
                                              keranjangModel.kuantitas.toString(),
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            // const SizedBox(width: 2,),

                                            //+ tambah kuantitas
                                            IconButton(
                                                onPressed: ()
                                                {
                                                  updateKuantitasDiKeranjang(
                                                    keranjangModel.keranjang_id!,
                                                    keranjangModel.kuantitas! + 1,
                                                  );

                                                },
                                                icon: Icon(
                                                  Icons.add_circle_outline,
                                                  color: Colors.grey,
                                                  size: 25,
                                                ),
                                             ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                //Item Gambar CopyPaste Fragmen_home.dart
                                ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(22),
                                    bottomRight: Radius.circular(22),
                                  ),
                                  child: FadeInImage(
                                    height: 190,
                                    width: 150,
                                    fit: BoxFit.cover,
                                    placeholder: AssetImage("images/placeholder.png"),
                                    image: NetworkImage(
                                      keranjangModel.gambar!,
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
                              ],
                            ),
                          ),
                        ),
                    ),
                  ],
                ),
              );
              },
            )
              : const Center(
            child: Text("Item di keranjang kosong"),
          ),),
      bottomNavigationBar: GetBuilder(
        init: ControllerListKeranjang(),
        builder: (c)
        {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              boxShadow:[
                BoxShadow(
                  offset: Offset(0, -3),
                  color: Colors.white24,
                  blurRadius: 6,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: Row(
              children: [

                //Total
                Text(
                  "Total semua : ",
                  style: TextStyle(
                    fontSize: 14,
                    color: controllerListKeranjang.seleksiItemList.length > 0
                        ? Colors.white
                        : Colors.white24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4,),

                Obx(() =>
                Text(
                  "Rp." + controllerListKeranjang.jumlah.toStringAsFixed(2), //44.23
                  maxLines: 1,
                  style: TextStyle(
                    color: controllerListKeranjang.seleksiItemList.length > 0
                        ? Colors.white
                        : Colors.white24,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    ),
                  ),),

                const Spacer(),

                //Order Bottom
                Material(
                  color: controllerListKeranjang.seleksiItemList.length > 0
                      ? Colors.white
                      : Colors.white24,
                  borderRadius: BorderRadius.circular(30),
                  child: InkWell(
                    onTap: ()
                    {
                      if(controllerListKeranjang.seleksiItemList.length > 0)
                      {
                        controllerListKeranjang.seleksiItemList.length > 0
                            ? Get.to(TampilanItemOrder(
                          seleksiListKeranjangItemInfo : getSeleksiKeranjangItemInformasi(),
                          total : controllerListKeranjang.jumlah,
                          seleksiKeranjangId : controllerListKeranjang.seleksiItemList,
                        ))
                            : null;
                      }
                      else
                      {
                        Fluttertoast.showToast(msg: "Ceklist dulu !");
                      }
                    },
                    child: const Padding(
                      padding:EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      child: Text(
                        "Order",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

    );
  }
}
