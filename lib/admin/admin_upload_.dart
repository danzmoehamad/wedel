import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wedel/admin/admin_login.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/api_koneksi/api_koneksi.dart';

import 'admin_get_semua_order.dart';


class AdminUploadScreen extends StatefulWidget {

  @override
  State<AdminUploadScreen> createState() => _AdminUploadScreenState();
}

class _AdminUploadScreenState extends State<AdminUploadScreen>
{
  var formKey = GlobalKey<FormState>();
  var userController = TextEditingController();
  var userNameController = TextEditingController();
  var passwordController = TextEditingController();
  var hideText  = true.obs;

  //Pakage Image Picker
  final ImagePicker _picker = ImagePicker();
  XFile? gambarXFileDipilih;

  var fromKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var hargaController = TextEditingController();
  var ukuranController = TextEditingController();
  var warnaController = TextEditingController();
  var deskripsiController = TextEditingController();

  var imageLink = "";



  //Tampilan Defaulth methods
  gambarCamera() async
  {
    gambarXFileDipilih = await _picker.pickImage(source: ImageSource.camera);
    Get.back();

    setState(()=>gambarXFileDipilih);
  }

  gambarGaleri() async
  {
    gambarXFileDipilih = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();

    setState(()=>gambarXFileDipilih);
  }


  tampilDialogBoxGambar()
  {
    return showDialog(
        context: context,
        builder: (context)
        {
          return SimpleDialog(
            backgroundColor: Colors.grey,
            title: const Text(
              "Item Gambar",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: ()
                {
                  gambarCamera();
                },
                child: const Text(
                  "Camera Handphone",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  gambarGaleri();
                },
                child: const Text(
                  "Pilih Gambar di HP",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: ()
                {
                  Get.back();
                },
                child: const Text(
                  "Batal",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        }
    );
  }
  //Tampilan Defaulth methods s/d disini


  Widget tampilanDefault()
  {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [
            //     Colors.white24,
            //     Colors.white,
            //   ]
            // ),
          ),
        ),
        automaticallyImplyLeading: false,

        //Text to wrap Wiget - widget rename to GestureDetektor
        title: GestureDetector(
          onTap: ()
          {
            Get.to(AdminGetSemuaOrder());
          },
          child: Text(
            "Oderan",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: ()
            {
              Get.to(TampilanLoginAdmin());
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,


            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Colors.black,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate_outlined,
                color: Colors.grey,
                size: 100,
              ),
              //Button
              SizedBox(height: 20,),
              Material(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: ()
                  {
                    tampilDialogBoxGambar();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text(
                      "Upload",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Upload Item
  uploadItemImage() async
  {
    var requestImgurApi = http.MultipartRequest(
      "POST",
      Uri.parse("https://api.imgur.com/3/image")
    );

    String namaImage = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = namaImage;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "cfdda64ed25010b";

    var fileImage = await http.MultipartFile.fromPath(
        'image',
        gambarXFileDipilih!.path,
        filename: namaImage,
    );
    requestImgurApi.files.add(fileImage);
    var responsDariImgurApi = await requestImgurApi.send();

    var responsDataDariImgurApi = await responsDariImgurApi.stream.toBytes();
    var resultDariImgurApi = String.fromCharCodes(responsDataDariImgurApi);

    print("Result :: " );
    print(resultDariImgurApi);

    Map<String, dynamic> jsonRes = json.decode(resultDariImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String hapusHashtag = (jsonRes["data"]["deletehash"]).toString();

    saveInfoItemKeDatabase();

    // print("ImageLink :: " );
    // print(imageLink);
    //
    // print("hapusHashtag :: " );
    // print(hapusHashtag);

  }

  saveInfoItemKeDatabase() async
  {
    List<String> tagsList = tagsController.text.split(','); // Data, Data2, Data3
    List<String> ukuranList = ukuranController.text.split(','); // Data, Data2, Data3
    List<String> warnaList = warnaController.text.split(','); // Data, Data2, Data3

    try
    {
      var response = await http.post(
        Uri.parse(API.uploadItems),
        body:
        {
          'item_id':'1',
          'nama': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'harga': hargaController.text.trim().toString(),
          'ukuran': ukuranList.toString(),
          'warna' : warnaList.toString(),
          'deskripsi' : deskripsiController.text.trim().toString(),
          'gambar' :imageLink.toString(),

        },
      );
      if(response.statusCode == 200)
        {
          var resBodyUploadItems = jsonDecode(response.body);

          if(resBodyUploadItems['sukses'] == true)
          {
            Fluttertoast.showToast(msg: "Item Baru telah diupload");

            setState(()
                {
                  gambarXFileDipilih=null;
                  nameController.clear();
                  ratingController.clear();
                  tagsController.clear();
                  hargaController.clear();
                  ukuranController.clear();
                  warnaController.clear();
                  deskripsiController.clear();
                });

            Get.to(AdminUploadScreen());
          }
          else
          {
            Fluttertoast.showToast(msg: "Data gagal diupload, coba lagi");
          }
        }
      else
        {
          Fluttertoast.showToast(msg: "Tidak berstatus 200");
        }
    }
    catch (errorMsg)
    {
      print("Error::" + errorMsg.toString());
    }
  }
  // s/d disini

  Widget tampilanUploadItem()
  {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
          ),
        ),
        automaticallyImplyLeading: false,
        title: Text(
          "Upload Form",
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: ()
          {
            Get.to(TampilanLoginAdmin());
          },
          icon : const Icon(
          Icons.clear,
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()
            {
              Get.to(TampilanLoginAdmin());
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [

          //Image
          Container(
            //non blank
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(gambarXFileDipilih!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //Upload Item Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Column(
                children: [
                  //Name,Username/Password Button
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(30,30,30,8),
                      child: Column(
                        children: [
                          //Nama item
                          TextFormField(
                            controller: nameController,
                            //required
                            validator: (val)  => val == "" ? "Isi nama item " : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.title,
                                color: Colors.black,
                              ),
                              hintText: "item..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //Rating
                          TextFormField(
                            controller: ratingController,
                            validator: (val)  => val == "" ? "Isi rating" : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.star_rate_rounded,
                                color: Colors.black,
                              ),
                              hintText: "rating..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //Tag
                          TextFormField(
                            controller: tagsController,
                            validator: (val)  => val == "" ? "Isi Tag" : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.tag,
                                color: Colors.black,
                              ),
                              hintText: "tags..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //Harga
                          TextFormField(
                            controller: hargaController,
                            validator: (val)  => val == "" ? "Isi harga" : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.price_change,
                                color: Colors.black,
                              ),
                              hintText: "harga..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //ukuran
                          TextFormField(
                            controller: ukuranController,
                            validator: (val)  => val == "" ? "Isi size" : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.format_size,
                                color: Colors.black,
                              ),
                              hintText: "ukuran..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //warna
                          TextFormField(
                            controller: warnaController,
                            validator: (val)  => val == "" ? "Isi warna" : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.closed_caption_off_rounded,
                                color: Colors.black,
                              ),
                              hintText: "warna..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //deskripsi
                          TextFormField(
                            controller: deskripsiController,
                            validator: (val)  => val == "" ? "Isi keterangan" : null,//Required
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.description,
                                color: Colors.black,
                              ),
                              hintText: "deskripsi..",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.white,

                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: const BorderSide(
                                  color: Colors.grey,

                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              fillColor: Colors.white,
                              filled: true,
                            ),
                          ),
                          const SizedBox(height: 18),
                          //Button
                          Material(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(30),
                            child: InkWell(
                              onTap: ()
                              {
                                if(formKey.currentState!.validate())
                                {
                                  Fluttertoast.showToast(msg: "Lagi Proses..");

                                  uploadItemImage();
                                }
                              },
                              borderRadius: BorderRadius.circular(30),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 28,
                                ),
                                child: Text(
                                  "Upload",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context)
  {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return gambarXFileDipilih == null ? tampilanDefault() : tampilanUploadItem();
  }
}
