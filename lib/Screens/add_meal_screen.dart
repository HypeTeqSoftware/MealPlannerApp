import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_tracker_app/Provider/match_data_provider.dart';
import 'package:meal_tracker_app/Screens/add_meal_image_picker_screen.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/Colors.dart';

class AddMealScreen extends StatefulWidget {
  const AddMealScreen({Key? key}) : super(key: key);

  @override
  State<AddMealScreen> createState() => _AddMealScreenState();
}

class _AddMealScreenState extends State<AddMealScreen> {

  String? valueChoose;
  List mealList = ["Breakfast", "Lunch", "Dinner", "Snacks", "Dessert"];
  final _formKey = GlobalKey<FormState>();

  final mealNameController = TextEditingController();
  final categoryController = TextEditingController();

  _openGoogle() async {
    const url = 'https://www.google.com';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> addMeal() {
    return FirebaseFirestore.instance
        .collection("addMealData")
        .doc(DateTime.now().microsecondsSinceEpoch.toString())
        .set({
      'meal_name': mealNameController.text.trim(),
      'category': valueChoose,
      'create_time': Provider.of<Matchdate>(context,listen: false).datestore,
      'current_id': FirebaseAuth.instance.currentUser!.uid,
    }).then((value) => print('Meal Added'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor:Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
          automaticallyImplyLeading: false,
          title: DefaultTextStyle(
            style: GoogleFonts.kalam(
                textStyle:TextStyle(
                    color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold)),
            child: AnimatedTextKit(
              animatedTexts: [
                WavyAnimatedText("Add Meal"),
              ],
              isRepeatingAnimation: false,
            ),
          ),
          centerTitle: true,
          // toolbarHeight: 100,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 30),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).brightness == Brightness.light ? Colors.green.shade100 : Colors.black54,
                            borderRadius: BorderRadius.circular(20)),
                        // height: MediaQuery.of(context).size.height/2.3,
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Text(
                                  "Category",
                                  style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 9),
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: MyColors.darkGreen), // Change the color here
                                    ),
                                  ),
                                  dropdownColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade100 : Colors.black,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                    fontSize: 18,
                                  ),
                                  value: valueChoose,
                                  onChanged: (newValue) {
                                    setState(() {
                                      valueChoose = newValue!;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter Category";
                                    }
                                    return null;
                                  },
                                  items: mealList.map((valueItem) {
                                    return DropdownMenuItem<String>(
                                      value: valueItem,
                                      child: Text(valueItem),
                                    );
                                  }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 5),
                                child: Text(
                                  "Meal name",
                                  style: TextStyle(
                                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 6),
                                child: TextFormField(
                                  controller: mealNameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter Meal name";
                                    }
                                    return null;
                                  },
                                  cursorColor: MyColors.darkGreen,
                                  decoration: InputDecoration(
                                    hintText: "Enter meal name",
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 20.0),
                                    filled: true,
                                    fillColor: Colors.green.withOpacity(0.6),
                                    border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: MyColors.green),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: MyColors.green),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).brightness == Brightness.light ? Colors.green : Colors.black26,
                    minimumSize: const Size(200, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          10), // set the button's border radius
                    ),
                  ),
                  onPressed: () {
                    _openGoogle();
                  },
                  child: Text(
                    'Search for recipe',
                    style: GoogleFonts.kalam(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
                const ImagePickerScreen()
              ],
            ),
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          child: BottomAppBar(
            color: Theme.of(context).brightness == Brightness.light ? Colors.green.shade400 : Colors.black54,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light ? Colors.green.shade400 : Colors.black54,
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30))),
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    addMeal().then((value) => Navigator.pop(context));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Please fill all detail",
                        backgroundColor: Colors.redAccent);
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).brightness == Brightness.light ? Colors.teal.withOpacity(0.8) : Colors.black54),
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(250, 50)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Save',
                        style: GoogleFonts.kalam(
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
