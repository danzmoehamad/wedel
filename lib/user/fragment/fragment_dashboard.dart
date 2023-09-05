import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:modern_form_line_awesome_icons/modern_form_line_awesome_icons.dart';
import 'package:wedel/user/fragment/fragment_home.dart';
import 'package:wedel/user/fragment/fragment_favorite.dart';
import 'package:wedel/user/fragment/fragment_profile.dart';
import 'package:wedel/user/fragment/fragment_order.dart';
import 'package:wedel/user/pengguna_preferences/pengguna_sekarang.dart';

class FragmentDashboard extends StatelessWidget
{
  PenggunaSekarang _savePenggunaUser = Get.put(PenggunaSekarang());
  List<Widget> _FragmenScreen =
  [
    FragmentHome(),
    FragmentFavorit(),
    FragmentOrder(),
    FragmentProfile(),
  ];

  List _tombolNavigasiProperti =
  [
    {
      "active_icon" : CupertinoIcons.house_alt_fill,
      "non_active_icon" : CupertinoIcons.house_alt,
      "label" : "Home",
    },
    {
      "active_icon" : CupertinoIcons.square_favorites_alt_fill,
      "non_active_icon" : CupertinoIcons.square_favorites_alt,
      "label" : "Favorite",
    },
    {
      "active_icon" : Icons.sell,
      "non_active_icon" : Icons.sell_outlined,
      "label" : "Order",
    },
    {
      "active_icon" : CupertinoIcons.person_fill,
      "non_active_icon" : CupertinoIcons.person,
      "label" : "Profil",
    },
  ];

  RxInt _indexNumber = 0.obs;

  @override
  Widget build(BuildContext context)
  {
    return GetBuilder(
      init:PenggunaSekarang(),
      initState: (currenState)
      {
        _savePenggunaUser.getUserInfo();
      },
      builder: (controller)
      {
        return Scaffold(
          backgroundColor: Colors.black12,
          body: SafeArea(
            child: Obx(
                    ()=> _FragmenScreen[_indexNumber.value]
            ),
          ),
          bottomNavigationBar: Obx(
                ()=> BottomNavigationBar(
              currentIndex: _indexNumber.value,
              onTap: (value)
              {
                _indexNumber.value = value;
              },
              showSelectedLabels: true,
              showUnselectedLabels: true,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.grey,
              items: List.generate(4, (index)
              {
                var navBtnProperti = _tombolNavigasiProperti[index];
                return BottomNavigationBarItem(
                  backgroundColor:Colors.black,
                  icon: Icon(navBtnProperti["non_active_icon"]),
                  activeIcon: Icon(navBtnProperti["active_icon"]),
                  label: navBtnProperti["label"],
                );
              }),
            ),
          ),

        );
      },
    );
  }
}
