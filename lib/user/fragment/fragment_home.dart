import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:wedel/api_koneksi/api_koneksi.dart';
import 'package:wedel/user/tampilan_item/tampilan_detail_item.dart';
import 'package:wedel/user/model/model_baju.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/tampilan_item/tampilan_pencarian_item.dart';
import 'package:wedel/user/tampilan_keranjang/tampilan_list_keranjang.dart';

class FragmentHome extends StatelessWidget
{
  TextEditingController searchController = TextEditingController();

  Future<List<ModelBaju>> getItemBajuTrending() async
  {
    List<ModelBaju> trendingLisItemBaju = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.getTrendingPopulerItem)
      );

      if(res.statusCode == 200)
      {
        var resBodyTrending = jsonDecode(res.body);
        if(resBodyTrending["sukses"] == true);
        {
          (resBodyTrending["dataItemBaju"] as List).forEach((diCatat)
          {
            trendingLisItemBaju.add(ModelBaju.fromJson(diCatat));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }

    return trendingLisItemBaju;

  }

  Future<List<ModelBaju>> getSemuaItemBaju() async
  {
    List<ModelBaju> semuaListItemBaju = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.getSemuaItem)
      );

      if(res.statusCode == 200)
      {
        var responBodySemuaItem = jsonDecode(res.body);
        if(responBodySemuaItem["sukses"] == true);
        {
          (responBodySemuaItem["dataItemBaju"] as List).forEach((diCatat)
          {
            semuaListItemBaju.add(ModelBaju.fromJson(diCatat));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
    }

    return semuaListItemBaju;

  }

  @override
  Widget build(BuildContext context) {
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
          //Search Widget
          showPencarianWidget(),

          SizedBox(height: 18,),
          //Yang lagi ngetrend
          const Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Text(
              "Trend",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),

          trendingBajuPopulerItemWidget(context),

          SizedBox(height: 18,),
          //Semua item trend
          Padding(
            padding: const EdgeInsets.only(left: 20,right: 20),
            child: Text(
              "New Collections",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          SizedBox(height: 18,),
          allItemBajuWidget(context),
        ],
      ),
    );
  }
  //Implementasi Tampilan SearchWidget
  Widget showPencarianWidget()
  {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: TextField(
        style: TextStyle(color: Colors.grey),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              //dapatkan menu pencarian
              Get.to(TampilanPencarianItem(kataKunci: searchController.text));
            },
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          hintText: "teangan......",
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 12,
          ),
          suffixIcon: IconButton(
            onPressed: ()
            {
              Get.to(TampilanListKeranjang());
            },
            icon: const Icon(
              Icons.shopping_cart,
              color: Colors.white,
            ),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color:Colors.grey,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color:Colors.grey,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color:Colors.white,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
  //Implementasi Tampilan Trend Item Widget
  trendingBajuPopulerItemWidget(context)
  {
    return FutureBuilder(
      future: getItemBajuTrending(),
      builder: (context, AsyncSnapshot<List<ModelBaju>> cuplikanData)
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
                "Item tidak ditemukan",
              ),
            );
          }
        if(cuplikanData.data!.length > 0)
          {
            return SizedBox(
              height: 260,
              child: ListView.builder(
                itemCount: cuplikanData.data!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index)
                {
                  //Model
                  ModelBaju eachBajuDataItem = cuplikanData.data![index];
                  return GestureDetector(
                    onTap: ()
                    {
                      Get.to(TampilanDetailItem(infoItem: eachBajuDataItem));
                    },
                    child:  Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0),
                      child: Container(
                        width: 200,
                        margin: EdgeInsets.fromLTRB(
                          index == 0 ? 16 : 8,
                          10,
                          index == cuplikanData.data!.length - 1 ? 16 : 8,
                          10,
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

                        child: Column(
                          children: [

                            //Menampilkan Gambar
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(22),
                                topRight: Radius.circular(22),
                              ),
                              child: FadeInImage(
                                height: 150,
                                width: 200,
                                fit: BoxFit.cover,
                                placeholder: AssetImage("images/placeholder.png"),
                                image: NetworkImage(
                                  eachBajuDataItem.gambar!,
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  //nama item & harga
                                  Row(
                                    children : [
                                    Expanded(
                                      child: Text(
                                        eachBajuDataItem.nama!,
                                        //mengurangi jumlah text
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                           ),
                                          ),
                                    ),

                                      const SizedBox(width: 10,),

                                      Text(
                                        eachBajuDataItem.harga.toString(),
                                        style: const TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ]
                                  ),

                                  const SizedBox(height: 8,),

                                  //Rating & nomor Rating
                                  Row(
                                    children: [
                                      //Rating bintang
                                      RatingBar.builder(
                                        initialRating : eachBajuDataItem.rating!,
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
                                      const SizedBox(width: 8,),

                                      Text(
                                        "(" + eachBajuDataItem.rating.toString() + ")",
                                        style: const TextStyle(
                                          color: Colors.grey,

                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
      },
    );
  }

  //Implementasi Tampilan Semua Item Widget
  allItemBajuWidget(context)
  {
    return FutureBuilder(
      future: getSemuaItemBaju(),
      builder: (context, AsyncSnapshot<List<ModelBaju>> cuplikanData)
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
              "Item tidak ditemukan",
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
                ModelBaju eachBajuItemGambarRecord = cuplikanData.data![index];
                return GestureDetector(
                  onTap: ()
                  {
                    Get.to(TampilanDetailItem(infoItem: eachBajuItemGambarRecord));
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
                                        eachBajuItemGambarRecord.nama!,
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
                                        "Rp." + eachBajuItemGambarRecord.harga.toString(),
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
                                 "Tags : "+ eachBajuItemGambarRecord.tags.toString().replaceAll("[", "").replaceAll("]", ""),
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
                              eachBajuItemGambarRecord.gambar!,
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
