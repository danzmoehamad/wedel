import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
import 'package:wedel/user/model/model_baju.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/tampilan_item/tampilan_detail_item.dart';

import '../../api_koneksi/api_koneksi.dart';
import '../tampilan_keranjang/tampilan_list_keranjang.dart';

class TampilanPencarianItem extends StatefulWidget
{

  final String? kataKunci;

  TampilanPencarianItem({this.kataKunci,});

  @override
  State<TampilanPencarianItem> createState() => _TampilanPencarianItemState();
}

class _TampilanPencarianItemState extends State<TampilanPencarianItem>
{
  TextEditingController searchController = TextEditingController();

  //Implementasi cari item di ModelBaju
  Future <List<ModelBaju>>cariDataItem() async
  {
    List<ModelBaju> cariItemBaju = [];

    //Kondisi
    if(searchController.text != "")
      {
        try
        {
          var res = await http.post(
              Uri.parse(API.cariItem),
              body:
              {
                "kataKunci": searchController.text,
              }
          );
          if (res.statusCode == 200)
          {
            var responBodyGetCariItem = jsonDecode(res.body);

            if(responBodyGetCariItem['sukses'] == true)
            {
              (responBodyGetCariItem['itemPencarian'] as List).forEach((dataDitemukan)
              {
                cariItemBaju.add(ModelBaju.fromJson(dataDitemukan));
              });
            }
          }
          else
          {
            Fluttertoast.showToast(msg: "Tidak berstatus 200");
          }
        }
        catch(errorMsg)
        {
          Fluttertoast.showToast(msg: "Error::laaah" + errorMsg.toString());
        }
      }

    return cariItemBaju;
  }


  @override
  void initState()
  {
    // TODO: implement initState
    super.initState();

    searchController.text = widget.kataKunci!;
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
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 10, right: 10),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: Colors.black,
          title: showPencarianWidget(),
          titleSpacing: 0,
          leading: IconButton(
            onPressed: ()
            {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        //Memanggil tampilan item yang dicari
        body: cariItemDesainWidget(context),
      ),
    );
  }

  Widget showPencarianWidget()
  {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 0, right: 0),
      child: TextField(
        style: TextStyle(color: Colors.grey),
        controller: searchController,
        decoration: InputDecoration(
          prefixIcon: IconButton(
            onPressed: ()
            {
              //dapatkan menu pencarian
              //refesh pencarian
              setState(() {
              });

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
              searchController.clear();
              setState(() {
              });
            },
            icon: const Icon(
              Icons.close,
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
  //Implementasi Tampilan Semua Item Widget
  cariItemDesainWidget(context)
  {
    return FutureBuilder(
        future: cariDataItem(),
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
                      10,
                      //Margin top 16
                      index == 16 ? 0 : 8,
                      10,
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
