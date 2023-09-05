import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:wedel/user/auth/auth_tampilan_login.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_preferences.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';
import 'package:wedel/widget/title_text.dart';


class FragmentProfile extends StatelessWidget
{
  final PenggunaSekarang _penggunaSekarang = Get.put(PenggunaSekarang());

  logoutUser() async
  {
    var resultRespon = await Get.dialog(
      AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          "Logout",
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold
          ),
        ),
        content: Text(
          "Yakin mau keluar ?",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()
            {
              Get.back();
            },
            child: Text(
              "Tidak",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          TextButton(
            onPressed: ()
            {
              Get.back(result: "logOut");
            },
            child: Text(
              "Iya",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
    );
    if(resultRespon == "logOut")
    {
      //Delete user pengguna logout dari storage pengguna_preferences.dart
      SavePengguna.hapusInfoUser()
          .then((value)
      {
        Get.off(TampilanLogin());
      });
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
                  Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(40),
                        child: Column(
                          children: [
                            // Text("tes", ),
                            Image.asset("images/profile.png", height: 60,),
                            // TitleTextWidget (label: "Profile", fontSize: 17,),
                            Image.asset("images/user.png", height: 130,),
                            SizedBox(height: 10,),
                            TitleTextWidget(label : _penggunaSekarang.user.nama, color: Colors.white,),
                            SizedBox(height: 20,),
                            //Password Read
                            SizedBox(height: 20,),
                            TextFormField(
                              enabled: false,
                              readOnly: true,
                              style: TextStyle(color: Colors.white),
                              // controller: username,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: _penggunaSekarang.user.password,
                                prefixIcon: const Icon(IconlyBold.lock,color: Colors.white,size: 21,),
                              ),
                            ),
                            TextFormField(
                              enabled: false,
                              readOnly: true,
                                style: TextStyle(color: Colors.white),
                                // controller: username,
                                decoration: InputDecoration(
                                  hintStyle: TextStyle(color: Colors.white),
                                  hintText: _penggunaSekarang.user.email,
                                  prefixIcon: const Icon(IconlyBold.message,color: Colors.white,size: 21,),
                                ),
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              enabled: false,
                              readOnly: true,
                              style: TextStyle(color: Colors.white),
                              // controller: username,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: _penggunaSekarang.user.alamat,
                                prefixIcon: const Icon(IconlyBold.location,color: Colors.white,size: 27,),
                              ),
                            ),
                            const SizedBox(height: 10,),
                            TextFormField(
                              enabled: false,
                              readOnly: true,
                              style: TextStyle(color: Colors.white),
                              // controller: username,
                              decoration: InputDecoration(
                                hintStyle: TextStyle(color: Colors.white),
                                hintText: _penggunaSekarang.user.nowa,
                                prefixIcon: const Icon(LineAwesomeIcons.phone,color: Colors.white,size: 21,),
                              ),
                            ),
                            const SizedBox(height: 30,),
                            Material(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: ()
                                {
                                  logoutUser();
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 28,
                                    ),
                                  child: Text(
                                    "Logout",
                                    style:TextStyle(color: Colors.white,fontSize:16,),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 100, right: 100),
                            //   child: SwitchListTile(
                            //     title: Text(
                            //         themeProvider.getIsDarkTheme ? "" : "" ),
                            //     value: themeProvider.getIsDarkTheme,
                            //     onChanged: (value) {
                            //       themeProvider.setDarkTheme(themevalue: value);
                            //     },
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
