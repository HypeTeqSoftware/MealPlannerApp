import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_tracker_app/Models/Colors.dart';
import 'package:meal_tracker_app/Provider/theme_changer_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  var nameValue = "";
  void getValue() async{
    var prefs = await SharedPreferences.getInstance();
    var getName = prefs.getString('myName');
    setState(() {
      nameValue = getName!;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Colors.black45,
                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
            ),child:   Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 40),
                child: Row(
                  children: [
                    Text("Setting",style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage("assets/pretty.jpg"),
                      radius: 40,
                    ),
                    const SizedBox(width: 15,),
                    Text("Hello $nameValue",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700,
                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                    ),)
                  ],
                ),
              )
            ],
          ),
          ),
          const SizedBox(height: 20,),
          settingItem(Icons.print, "Print"),
          const SizedBox(height: 15,),
          settingItem(Icons.share, "Share menu"),
          const SizedBox(height: 15,),
          InkWell(
            onTap: (){
              themeDialogBox();
            },
              child: settingItem(Icons.light_mode, "Theme")),
          const SizedBox(height: 15,),
          settingItem(Icons.star_rate_rounded, "Rate this app"),
          const SizedBox(height: 15,),
          settingItem(Icons.policy, "Privacy Policy"),
          const SizedBox(height: 15),
          settingItem(Icons.feedback, "Feedback"),
        ],
      ),
    );
  }
  Widget settingItem(IconData icon,String name){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration:
                BoxDecoration(
                  color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(.4),
                  borderRadius: BorderRadius.circular(40), //<-- SEE HERE
                ),
                child: Icon(icon),
              ),
              const SizedBox(width: 15,),
              Text(name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)

            ],
          )
        ],
      ),
    );
  }

  themeDialogBox(){
    final themeChanger=Provider.of<ThemeChanger>(context,listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 10,
            backgroundColor:Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            title: Text("Change Theme",
                style: GoogleFonts.mukta(
                  textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            content: Container(
              height: 180,
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                      title: const Text("Light Mode",style: TextStyle(fontWeight: FontWeight.bold),),
                      value: ThemeMode.light,
                      groupValue: themeChanger.themeMode,
                      onChanged:(value) {
                        themeChanger.setTheme(value);
                        Navigator.pop(context);
                      }
                  ),
                  RadioListTile<ThemeMode>(
                      title: const Text("Dark Mode",style: TextStyle(fontWeight: FontWeight.bold)),
                      value: ThemeMode.dark,
                      groupValue: themeChanger.themeMode,

                      onChanged:(value) {
                        themeChanger.setTheme(value);
                        Navigator.pop(context);
                      }
                  ),
                  RadioListTile<ThemeMode>(
                      title: const Text("System Mode",style: TextStyle(fontWeight: FontWeight.bold)),
                      value: ThemeMode.system,
                      groupValue: themeChanger.themeMode,
                      onChanged:(value) {
                        themeChanger.setTheme(value);
                        Navigator.pop(context);
                      }
                  )
                ],
              ),
            ),
          );
        });
  }
}
