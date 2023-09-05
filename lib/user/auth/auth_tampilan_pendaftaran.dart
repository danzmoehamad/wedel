import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wedel/api_koneksi/api_koneksi.dart';
import 'package:wedel/user/auth/auth_tampilan_login.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/model/model_user.dart';

import '../../widget/subtitle_text.dart';

class TampilanPendaftaran extends StatefulWidget
{

  @override
  State<TampilanPendaftaran> createState() => _TampilanPendaftaranState();
}

class _TampilanPendaftaranState extends State<TampilanPendaftaran> {

  var formKey = GlobalKey<FormState>();
  var namaController = TextEditingController();
  var userEmailController = TextEditingController();
  var passwordController = TextEditingController();
  var alamatController = TextEditingController();
  var nowaController = TextEditingController();
  var hideText  = true.obs;

  validateUserName() async
  {
    try
        {
          var res = await http.post(
            Uri.parse(API.validasiUsername),
            body:{
              'email' : userEmailController.text.trim(),
            },
          );
          if (res.statusCode == 200) // Koneksi dengan API ke server == Sukses
          {
            var resBodyValidasiUsername = jsonDecode(res.body);
            if(resBodyValidasiUsername['userEmail'] == true)
              {
                Fluttertoast.showToast(msg: "Email sudah terdaftar");
              }
            else
              {
                //User suskes terdaftar
                pendaftaranUserRecord();

              }
          }
        }
          catch(e)
        {
          print(e.toString());
          Fluttertoast.showToast(msg: e.toString());
        }

  }

  pendaftaranUserRecord() async
  {
    ModelUser userModel = ModelUser(
      1,
      namaController.text.trim(),
      userEmailController.text.trim(),
      passwordController.text.trim(),
      alamatController.text.trim(),
      nowaController.text.trim(),
    );

    try
    {
      var res = await http.post(
        Uri.parse(API.daftarUser),
        body: userModel.toJson(),
      );
      if(res.statusCode == 200)// Koneksi dengan API ke server == Sukses
      {
        var resBodyPendaftaran = jsonDecode(res.body);
        if (resBodyPendaftaran['sukses'] == true)
          {
            Fluttertoast.showToast(msg: "Pendaftaran Berhasil");
            //Membersihkan Kolom
            setState(() {
              namaController.clear();
              userEmailController.clear();
              passwordController.clear();
              alamatController.clear();
              nowaController.clear();
            });
          }
        else
          {
            Fluttertoast.showToast(msg: "Pendaftaran Gagal");
          }
      }
    }
    catch(e)
    {
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());

    }
  }


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, cons)
        {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: cons.maxHeight,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //Login Header
                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: SizedBox(height: 20,),
                  ),
                  Image.asset(
                    "images/wedel_header.png",
                    height: 150,
                  ),
                  SizedBox(height: 5,),
                  const Text(
                    ". WEDEL MEMBER .",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  //Login Form
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(
                          Radius.circular(60),
                        ),
                      ),
                      child: Column(
                        children: [
                          //Username,Password Button
                          Form(
                            key: formKey,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(30,30,30,8),
                              child: Column(
                                children: [
                                  //Nama
                                  TextFormField(
                                    style: TextStyle(color: Colors.black54),
                                    controller: namaController,
                                    validator: (val)  => val == "" ? "nama user" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.black,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black54),
                                      hintText: "nama....",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                  //Email
                                  TextFormField(
                                    style: TextStyle(color: Colors.black54),
                                    controller: userEmailController,
                                    validator: (val)  => val == "" ? "email user" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.alternate_email,
                                        color: Colors.black,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black54),
                                      hintText: "email....",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                  //Password
                                  Obx(
                                        ()=> TextFormField(
                                      controller: passwordController,
                                      obscureText: hideText.value,
                                      validator: (val)  => val == "" ? "maasukan password" : null,//Required
                                      decoration: InputDecoration(
                                        prefixIcon: const Icon(
                                          Icons.vpn_key_sharp,
                                          color: Colors.black,
                                        ),

                                        //Hidden Text Form Password
                                        suffixIcon: Obx(
                                              ()=> GestureDetector(
                                            onTap: ()
                                            {
                                              hideText.value = !hideText.value;
                                            },
                                            child: Icon(
                                              hideText.value ? Icons.visibility_off : Icons.visibility,
                                              color: Colors.black,

                                            ),
                                          ),
                                        ),
                                        hintText: "password..",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,

                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,

                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: const BorderSide(
                                            color: Colors.grey,

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
                                  ),

                                  SizedBox(height: 16),
                                  //Alamat
                                  TextFormField(
                                    style: TextStyle(color: Colors.black54),
                                    controller: alamatController,
                                    validator: (val)  => val == "" ? "alamat user" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.home,
                                        color: Colors.black,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black54),
                                      hintText: "alamat....",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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

                                  SizedBox(height: 16),
                                  //No. WA
                                  TextFormField(
                                    style: TextStyle(color: Colors.black54),
                                    controller: nowaController,
                                    validator: (val)  => val == "" ? "no. wa" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.phone,
                                        color: Colors.black,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black54),
                                      hintText: "no. wa....",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,

                                        ),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
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
                                  // Register Akun - Button
                                  const SizedBox(height: 20),
                                  //Button
                                  Container(
                                    width: MediaQuery.of(context).size.width * 10.6,
                                    child: Material(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: ()
                                        {
                                          if(formKey.currentState!.validate())
                                          {
                                            //Validasi Username
                                            validateUserName();
                                          }
                                        },
                                        borderRadius: BorderRadius.circular(30),
                                        child: const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28,
                                          ),
                                          child: Text(
                                            "Login",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // //Login Admin - Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(label :
                              "Login User ?", color: Colors.grey, fontSize: 14,
                              ),
                              TextButton(
                                onPressed: ()
                                {
                                  Get.to(TampilanLogin());
                                },
                                child: const Text(
                                  "Klik disini",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 5),

                  //Footer
                  Container(
                      padding: const EdgeInsets.all(5),
                      // color:Colors.blue,
                      alignment: Alignment.center,
                      child: const Text("Powered By dminc.id",
                        style: TextStyle(color: Colors.grey,
                            fontSize: 12),)
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
