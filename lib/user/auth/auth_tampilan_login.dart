import 'dart:convert';
// import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wedel/admin/admin_login.dart';
import 'package:wedel/api_koneksi/api_koneksi.dart';
import 'package:wedel/user/auth/auth_tampilan_pendaftaran.dart';
import 'package:http/http.dart' as http;
import 'package:wedel/user/fragment/fragment_dashboard.dart';
import 'package:wedel/user/model/model_user.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_preferences.dart';
import 'package:wedel/widget/title_text.dart';
import 'package:wedel/widget/subtitle_text.dart';

class TampilanLogin extends StatefulWidget
{

  @override
  State<TampilanLogin> createState() => _TampilanLoginState();
}

class _TampilanLoginState extends State<TampilanLogin> {

  var formKey = GlobalKey<FormState>();
  var userEmailController = TextEditingController();
  var passwordController = TextEditingController();
  var hideText  = true.obs;

  loginUser() async
  {
    try
    {
      var res = await http.post(
        Uri.parse(API.loginAkses),
        body: {
          "email":userEmailController.text.trim(),
          "password":passwordController.text.trim(),
        },
      );
      if(res.statusCode == 200)// Koneksi dengan API ke server == Sukses
          {
        var resBodyLogin = jsonDecode(res.body);
        if (resBodyLogin['sukses'] == true)
        {
          Fluttertoast.showToast(msg: "Login Berhasil");
          // setState(() {
          //   userNameController.clear();
          //   passwordController.clear();
          // });
          //model_user.dart (Model)
          ModelUser userInfo = ModelUser.fromJson(resBodyLogin["userData"]);

          //Save userInfo ke penyimpanan lokal -- pengguna_pereferences.dart
          await SavePengguna.SavePenggunaUser(userInfo);

          //Akses ke Halaman Dashboard dari Tampilan Login
          Future.delayed(Duration(milliseconds: 2000), ()
          {
            Get.to(FragmentDashboard());
          });
        }
        else
        {
          Fluttertoast.showToast(msg: "Cek Email & Password !\nLogin gagal, coba lagi");
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "tidak berstatus 200");
      }
    }
    catch(errorMsg)
    {
      print("Error :: " + errorMsg.toString());
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
                    padding: const EdgeInsets.only(top:100),
                    child: SizedBox(height: 20,),
                  ),
                  Image.asset(
                    "images/wedel_header.png",
                    height: 150,
                  ),
                  SizedBox(height: 5,),
                 const Text(
                     ". WEDEL .",
                   style: TextStyle(
                       color: Colors.white,
                       fontSize: 30,
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
                        // boxShadow: [
                        //   BoxShadow(
                        //     blurRadius: 8,
                        //     color: Colors.white,
                        //     offset: Offset(0, -3),
                        //
                        //   ),
                        // ],
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
                                  //User
                                  TextFormField(
                                    style: TextStyle(color: Colors.black54),
                                    controller: userEmailController,
                                    validator: (val)  => val == "" ? "masukan email user" : null,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(
                                        Icons.alternate_email,
                                        color: Colors.black,
                                      ),
                                      hintStyle: TextStyle(color: Colors.black54),
                                      hintText: "email..",
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
                                      style: TextStyle(color: Colors.black54),
                                      controller: passwordController,
                                      obscureText: hideText.value,
                                      validator: (val)  => val == "" ? "masukan password" : null,
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
                                        hintStyle: TextStyle(color: Colors.black54),
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
                                  ),
                                  SizedBox(height: 16),
                                  // Register Akun - Button
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "Belum punya akun ?",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      TextButton(
                                        onPressed: ()
                                        {
                                          Get.to(TampilanPendaftaran());

                                        },
                                        child: const Text(
                                          "Daftar disini",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  //Button
                                  Container(
                                    width: MediaQuery.of(context).size.width * 10.6,
                                    child: Material(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(30),
                                      child: InkWell(
                                        onTap: ()
                                        {
                                          if (formKey.currentState!.validate())
                                          {
                                            Fluttertoast.showToast(msg: "Proses Login...");
                                            Get.to(loginUser());
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
                                  "Login Admin ?", color: Colors.grey, fontSize: 14,
                              ),
                              TextButton(
                                onPressed: ()
                                {
                                  Get.to(TampilanLoginAdmin());
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

                  SizedBox(height: 10),

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
