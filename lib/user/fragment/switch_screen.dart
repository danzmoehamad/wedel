import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wedel/provider/theme_provider.dart';

class SwitchScreen extends StatelessWidget {
  // const SwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      // backgroundColor: AppColor.lightScaffoldColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Add Text
            // const SubtitleTextWidget(
            //   label: "Hello World",
            // ),
            // TitleTextWidget(
            //   label:"Helo World" * 1,
            // ),
            // ElevatedButton(
            //   onPressed: ()
            //   {
            //
            //   },
            //   child: const Text("Hay"),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 100, right: 100),
              child: SwitchListTile(
                title: Text(
                    themeProvider.getIsDarkTheme ? "Dark Mode" : "Light Mode"),
                value: themeProvider.getIsDarkTheme,
                onChanged: (value) {
                  themeProvider.setDarkTheme(themevalue: value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

