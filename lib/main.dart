import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wedel/user/auth/auth_tampilan_login.dart';
import 'package:wedel/user/fragment/fragment_dashboard.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_preferences.dart';


void main()
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Wedel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        //Tampilan tetap pada hak akses pengguna (pengguna_preferences.dart)
        future: SavePengguna.membacaUser(),
        builder: (context, dataSnapShot)
        {
          if(dataSnapShot.data == null)
          {
            return TampilanLogin();
          }
          else return FragmentDashboard();
        },
      ),
    );
  }
}
