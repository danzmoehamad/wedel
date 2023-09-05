import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wedel/user/model/model_baju.dart';
import 'package:wedel/user/model/model_favorite.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';

import '../../api_koneksi/api_koneksi.dart';
import '../tampilan_item/tampilan_detail_item.dart';


class FragmentFavorit extends StatelessWidget
{
  final penggunaSekarang = Get.put(PenggunaSekarang());


  Future<List<ModelFavorite>> getFavoriteUserList() async
  {
    List<ModelFavorite>favoriteListUser = [];
    try
    {
      var res = await http.post(
          Uri.parse(API.readFavorite),
          body:
          {
            "user_id":penggunaSekarang.user.user_id.toString(),
          }
      );
      if (res.statusCode == 200)
      {
        var responBodyGetFavoritePenggunaUser = jsonDecode(res.body);

        if(responBodyGetFavoritePenggunaUser['sukses'] == true)
        {
          (responBodyGetFavoritePenggunaUser['dataFavoriteUser'] as List).forEach((eachPenggunaFavoriteUserItem)
          {
            favoriteListUser.add(ModelFavorite.fromJson(eachPenggunaFavoriteUserItem));
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

    return favoriteListUser;
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 8, 8),
            child: Text(
              "Favorit",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(16, 10, 8, 8),
            child: Text(
              "Order produk favoritmu !",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 24,),
          //Display favorite
        favoriteItemDesainWidget(context),
        ],
      ),
    );
  }

  //Implementasi Tampilan Semua Favorite
  favoriteItemDesainWidget(context)
  {
    return FutureBuilder(
        future: getFavoriteUserList(),
        builder: (context, AsyncSnapshot<List<ModelFavorite>> cuplikanData)
        {
          if(cuplikanData.connectionState == ConnectionState.waiting)
          {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(cuplikanData.data == null)
          {
            return Center(
              child: Text(
                "Data tidak ditemukan",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            );
          }
          if(cuplikanData.data!.length > 0)
          {
            return ListView.builder(
              itemCount: cuplikanData.data!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index)
              {
                ModelFavorite eachFavoriteItem = cuplikanData.data![index];

                ModelBaju klikBajuItem = ModelBaju (
                  item_id: eachFavoriteItem.item_id,
                  warna: eachFavoriteItem.warna,
                  nama: eachFavoriteItem.nama,
                  harga: eachFavoriteItem.harga,
                  rating: eachFavoriteItem.rating,
                  ukuran: eachFavoriteItem.ukuran,
                  deskripsi: eachFavoriteItem.deskripsi,
                  gambar: eachFavoriteItem.gambar,
                  tags: eachFavoriteItem.tags,
                );
                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(TampilanDetailItem(infoItem: klikBajuItem));
                  },
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                      16,
                      //Margin top 0
                      index == 0 ? 0 : 8,
                      16,
                      index == cuplikanData.data!.length - 1 ? 16 : 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0,3),
                          blurRadius: 6,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        //Nama + harga
                        //Tags
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                //nama & harga
                                Row(
                                  children: [

                                    //nama
                                    Expanded(
                                      child: Text(
                                        eachFavoriteItem.nama!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    //Harga
                                    Padding(
                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                      child: Text(
                                        "Rp." + eachFavoriteItem.harga.toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16,),

                                //Tags
                                Text(
                                  //Menghilangkan [] di database
                                  "Tags : "+ eachFavoriteItem.tags.toString().replaceAll("[", "").replaceAll("]", ""),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        //Menampilkan Gambar
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: FadeInImage(
                            height: 130,
                            width: 130,
                            fit: BoxFit.cover,
                            placeholder: AssetImage("images/placeholder.png"),
                            image: NetworkImage(
                              eachFavoriteItem.gambar!,
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
                );
              },
            );
          }
          else
          {
            return const Center(
              child: Text(
                  "Data Kosong."
              ),
            );
          }
        }
    );
  }

}
