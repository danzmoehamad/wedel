import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wedel/user/controller/controller_detail_item.dart';
import 'package:wedel/user/model/model_baju.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';
import 'package:wedel/user/tampilan_keranjang/tampilan_list_keranjang.dart';

import '../../api_koneksi/api_koneksi.dart';

class TampilanDetailItem extends StatefulWidget
{
  final ModelBaju? infoItem;
  TampilanDetailItem({this.infoItem,});

  @override
  State<TampilanDetailItem> createState() => _TampilanDetailItemState();
}

class _TampilanDetailItemState extends State<TampilanDetailItem>
{                                      //controller_detail_item.dart
  final controllerDetailItem = Get.put(ControllerDetailItem());
                              //pengguna_sekarang.dart
  final penggunaOnlineUser = Get.put(PenggunaSekarang()); //1

  addKeranjangItem() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.addSemuaBaju),
        body: {
          //Database tabel Keranjang
          "user_id" : penggunaOnlineUser.user.user_id.toString(),  //2
          "item_id" : widget.infoItem!.item_id.toString(),
          "kuantitas" : controllerDetailItem.kuantitas.toString(),
          "warna_item" : widget.infoItem!.warna![controllerDetailItem.warna],
          "ukuran_item" : widget.infoItem!.ukuran![controllerDetailItem.ukuran],

        },
      );
      //CopyPaste auth_tampilan_login.dart
      if(res.statusCode == 200)// Koneksi dengan API ke server == Sukses
          {
        var resBodyTambahKeranjang = jsonDecode(res.body);
        if (resBodyTambahKeranjang['sukses'] == true)
        {
          Fluttertoast.showToast(msg: "Item baru berhasil ditambahkan");
        }
        else
        {
          Fluttertoast.showToast(msg: "Koreksi lagi lurr, Coba lagi !");
        }
      }
      else
        {
          Fluttertoast.showToast(msg: "tidak berstatus 200");
        }
    }
    catch(errorMsg)
    {
      print("Error :: "+ errorMsg.toString());
    }
  }

  validasiFavoriteList() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.validasiFavorite),
        body: {
          //Database tabel favorite
          "user_id" : penggunaOnlineUser.user.user_id.toString(),  //2
          "item_id" : widget.infoItem!.item_id.toString(),
        },
      );
      if(res.statusCode == 200)// Koneksi dengan API ke server == Sukses
          {
        var resBodyValidasiFavorite = jsonDecode(res.body);
        if (resBodyValidasiFavorite['favoriteTersedia'] == true)
        {
          // Fluttertoast.showToast(msg: "Favorite item berhasil tersimpan");

          controllerDetailItem.setTerFavorite(true);
        }
        else
        {
          // Fluttertoast.showToast(msg: "Item favorite gagal tersimpan, Coba lagi !");

          controllerDetailItem.setTerFavorite(false);
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "tidak berstatus 200");
      }
    }
    catch (errorMsg)
    {
      print("Error :: "+ errorMsg.toString());
    }
  }

  addFavoriteItem() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.tambahFavorite),
        body: {
          //Database tabel favorite
          "user_id" : penggunaOnlineUser.user.user_id.toString(),  //2
          "item_id" : widget.infoItem!.item_id.toString(),
        },
      );
      if(res.statusCode == 200)// Koneksi dengan API ke server == Sukses
       {
        var resBodyTambahFavorite = jsonDecode(res.body);
        if (resBodyTambahFavorite['sukses'] == true)
        {
          Fluttertoast.showToast(msg: "Item favorit, berhasil tersimpan");
          //Memanggil validasi favorite
          validasiFavoriteList();
        }
        else
        {
          Fluttertoast.showToast(msg: "Favorite item gagal tersimpan , Coba lagi !");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "tidak berstatus 200");
      }
    }
    catch (errorMsg)
    {
      print("Error :: "+ errorMsg.toString());
    }
  }

  hapusFavoriteItem () async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.hapusFavorite),
        body: {
          //Database tabel Keranjang
          "user_id" : penggunaOnlineUser.user.user_id.toString(),  //2
          "item_id" : widget.infoItem!.item_id.toString(),
        },
      );
      if(res.statusCode == 200)// Koneksi dengan API ke server == Sukses
      {
        var resBodyHapusFavorite = jsonDecode(res.body);
        if (resBodyHapusFavorite['sukses'] == true)
        {
          Fluttertoast.showToast(msg: "Item favorite berhasil dihapus");

          //Memanggil validasi favorite
          validasiFavoriteList();

        }
        else
        {
          Fluttertoast.showToast(msg: "Item favorite gagal terhapus , Coba lagi !");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "tidak berstatus 200");
      }

    }
    catch (errorMsg)
    {
      print("Error :: "+ errorMsg.toString());
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    validasiFavoriteList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          //Item Image
          FadeInImage(
            height: MediaQuery.of(context).size.height * 0.5,
            width:  MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
            placeholder: AssetImage("images/placeholder.png"),
            image: NetworkImage(
              widget.infoItem!.gambar!,
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

          //Informasi Item
          Align(
            alignment: Alignment.bottomCenter,
            child: infoItemWidget(
            ),
          ),

          //3 button - back - Favorit - shoping
          Positioned(
            top: MediaQuery.of(context).padding.top,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.transparent,
              child: Row(
                children: [
                  IconButton(
                    onPressed: ()
                    {
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),

                  const Spacer(),
                  //Favorite
                  Obx(() => IconButton(
                      onPressed:()
                      {
                        if (controllerDetailItem.favorit == true)
                          {

                            //hapus item dari list favorit
                            hapusFavoriteItem();

                          }
                        else
                          {
                            //Simpan item ke list favorit
                            addFavoriteItem();
                          }
                      },
                    icon: Icon(
                      controllerDetailItem.favorit
                          ? Icons.bookmark
                          : Icons.bookmark_border_outlined,
                      color: Colors.white,
                      ),
                    ),
                  ),

                  //Shoping
                  IconButton(
                    onPressed: ()
                    {
                      Get.to(TampilanListKeranjang());

                    },
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  infoItemWidget()
  {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.6,
      width: MediaQuery.of(Get.context!).size.width,
      decoration: const BoxDecoration(
        color:Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -3),
            blurRadius: 6,
            color: Colors.black45,


          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18,),

            //Membuat Line
            Center(
              child: Container(
                height: 6,
                width: 140,
                decoration: BoxDecoration(
                color:Colors.grey,
                  borderRadius: BorderRadius.circular(30),

                ),
              ),
            ),
            const SizedBox(height: 30,),

            //Nama
            Text(
              widget.infoItem!.nama!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30,),
            //Rating +
            //Tags
            //Harga
            //Item
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Rating +
                //Tags
                //Harga
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //Rating + num
                      Row(
                        children: [
                          //Rating Bar
                          RatingBar.builder(
                            initialRating : widget.infoItem!.rating!,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemBuilder: (context, c)=> const Icon(
                              Icons.star,
                              color: Colors.amberAccent,
                            ),
                            onRatingUpdate: (updateRating){},
                            ignoreGestures: true,
                            unratedColor: Colors.grey,
                            itemSize: 20,
                          ),

                          const SizedBox(height: 8,),

                          //Rating Num
                          Text(
                            " (" + widget.infoItem!.rating.toString() + ")",
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10,),

                      //Tags
                      Text(
                        widget.infoItem!.tags!.toString().replaceAll("[","").replaceAll("]", ""),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 16,),

                      //Harga
                      Text(
                        "Rp." + widget.infoItem!.harga.toString(),
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                //Item/Produk Kuantitas Counter
                Obx(
                      ()=>Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //+ Plus
                      IconButton(
                        onPressed: ()
                        {                     //controller_detail_item.dart
                          controllerDetailItem.setKuantitasItem(controllerDetailItem.kuantitas + 1);
                        },
                        icon : const Icon(Icons.add_circle_outline, color: Colors.white),
                      ),
                      Text(                 //controller_detail_item.dart
                        controllerDetailItem.kuantitas.toString(), //Value3
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      //- Mines
                      IconButton(
                        onPressed: ()
                        {
                          if(controllerDetailItem.kuantitas - 1 >= 1)
                          {
                            //controller_detail_item.dart
                            controllerDetailItem.setKuantitasItem(controllerDetailItem.kuantitas - 1);
                          }
                          else
                          {
                            Fluttertoast.showToast(msg: "Minimal hiji lur,.");
                          }
                        },
                        icon : const Icon(Icons.remove_circle_outline, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            //Ukuran
            const Text(
              "Ukuran:",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const  SizedBox(height: 8,),
            //Box Ukuran
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.infoItem!.ukuran!.length, (index)
                {
                  return Obx(
                      ()=> GestureDetector(
                        onTap: ()
                        {
                          controllerDetailItem.setUkuranItem(index);
                        },
                        child: Container(
                          height: 35,
                          width: 60,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: controllerDetailItem.ukuran == index
                                  ? Colors.transparent
                                  : Colors.grey,

                            ),
                            color: controllerDetailItem.ukuran == index
                                ? Colors.grey.withOpacity(0.3)
                                : Colors.black,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.infoItem!.ukuran![index].replaceAll("[", "").replaceAll("]", ""),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                  );
                }),
            ),

            const SizedBox(height: 20,),

            //Warna
            const Text(
              "Warna:",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const  SizedBox(height: 8,),
            //Box Ukuran
            Wrap(
              runSpacing: 8,
              spacing: 8,
              children: List.generate(widget.infoItem!.warna!.length, (index)
              {
                return Obx(
                      ()=> GestureDetector(
                    onTap: ()
                    {
                      controllerDetailItem.setWarnaItem(index);
                    },
                    child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: controllerDetailItem.warna == index
                              ? Colors.transparent
                              : Colors.grey,

                        ),
                        color: controllerDetailItem.warna == index
                            ? Colors.grey.withOpacity(0.3)
                            : Colors.black,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        widget.infoItem!.warna![index].replaceAll("[", "").replaceAll("]", ""),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 20,),

            //Deskripsi
            const Text(
              "Keterangan:",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.infoItem!.deskripsi!,
              //Merapihkan Text
              textAlign: TextAlign.justify,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 30,),
            //Add Button
            Material(
              elevation: 4,
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: ()
                {
                  addKeranjangItem();
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  child: const Text(
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
            const SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
