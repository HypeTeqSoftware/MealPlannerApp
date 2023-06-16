import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meal_tracker_app/Provider/match_data_provider.dart';
import 'package:meal_tracker_app/Provider/login_sharedpreference_provider.dart';
import 'package:meal_tracker_app/Provider/theme_changer_provider.dart';
import 'package:meal_tracker_app/Screens/NavBarRoots.dart';
import 'package:meal_tracker_app/Screens/on_boarding_screen.dart';
import 'package:provider/provider.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (BuildContext context) => Matchdate()),
    ChangeNotifierProvider(create: (BuildContext context) => ThemeChanger()),
    ChangeNotifierProvider(create: (BuildContext context) => LoginSharedPreferenceProvider()),
  ], child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  bool isLogin = false;

  @override
  void initState() {
    Provider.of<LoginSharedPreferenceProvider>(context,listen: false).getValue();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Builder(builder: (BuildContext context){
            return Consumer<LoginSharedPreferenceProvider>(
              builder: (context, provider,_) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Meal Planner',
                  themeMode: Provider.of<ThemeChanger>(context).themeMode,
                  theme: ThemeData(
                      brightness: Brightness.light
                  ),
                  darkTheme: ThemeData(
                    brightness: Brightness.dark,

                  ),
                  home: provider.getBoolLogin == true?const NavBarRoots():const On_Boarding_screen(),
                );
              }
            );
          });
        });
  }
}
