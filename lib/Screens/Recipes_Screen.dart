import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_tracker_app/Provider/match_data_provider.dart';
import 'package:meal_tracker_app/Screens/add_meal_screen.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Models/Colors.dart';

class RecipeScreen extends StatefulWidget {
  String? calories;
  double? val;
  RecipeScreen({this.calories, this.val, Key? key}) : super(key: key);

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen>
    with SingleTickerProviderStateMixin {
  String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  final Stream<QuerySnapshot<Map<String, dynamic>>> mealStream =
      FirebaseFirestore.instance
          .collection("addMealData")
          .where('current_id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy('create_time', descending: true)
          .snapshots();
  CollectionReference addnewmeal =
      FirebaseFirestore.instance.collection('addMealData');

  bool isLoading = false;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late final Animation<Offset> _listAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(1.5, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.elasticIn,
  ));
  final mealNameController = TextEditingController();
  final categoryController = TextEditingController();
  // final CalendarController _calendarController = CalendarController();
  @override
  void initState() {
    repeatOnce();
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if(mounted){
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  void repeatOnce() async {
    await _controller.forward();
    await _controller.reverse();
  }

  Future<void> updateMeal(id) {
    return FirebaseFirestore.instance.collection("addMealData").doc(id).update({
      'meal_name': mealNameController.text.trim(),
      'create_time': Provider.of<Matchdate>(context, listen: false).datestore,
    }).then((value) => Navigator.pop(context));
  }

  DateTime _focusDay = DateTime.now();
  DateFormat dateFormat = DateFormat('yyyy-MM-dd');
  void _onDaySelected(DateTime day, DateTime focusedDay) {
    setState(() {
      _focusDay = day;
    });
    Provider.of<Matchdate>(context, listen: false)
        .storeDate(dateFormat.format(_focusDay));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade200 : Colors.black,
            ),
        elevation: 0,
        backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Text("Meal Planner",
              style: GoogleFonts.anekOdia(
                  textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,

                      fontSize: 28,
                      fontWeight: FontWeight.bold))),
        ),
        centerTitle: true,
        // toolbarHeight: 100,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: mealStream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 100.0),
                      child: Lottie.asset('assets/foddloading.json',
                          height: 200, width: 200),
                    ),
                  ),
                  Text(
                    "Foraging Best Recipes",
                    style: GoogleFonts.kalam(
                      textStyle: TextStyle(
                          color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              );
            } else if (snapshot.hasError) {
              print("Something went wrong");
              return Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 100.0),
                      child: Lottie.asset('assets/foddloading.json',
                          height: 200, width: 200),
                    ),
                  ),
                  Text(
                    "Foraging Best Recipes",
                    style: GoogleFonts.kalam(
                      textStyle: const TextStyle(
                          color: MyColors.darkGreen,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              );
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        decoration: BoxDecoration(
                            color:Theme.of(context).brightness == Brightness.light ? Colors.white: Colors.black,
                            borderRadius: BorderRadius.circular(20)),
                        child: TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime(2024),
                          focusedDay: _focusDay,
                          availableCalendarFormats: const {
                            CalendarFormat.week: 'Week',
                          },
                          calendarFormat: CalendarFormat.week,
                          startingDayOfWeek: StartingDayOfWeek.monday,
                          rowHeight: 60,
                          daysOfWeekHeight: 40,
                          selectedDayPredicate: (day) =>
                              isSameDay(day, _focusDay),
                          onDaySelected: _onDaySelected,
                          headerStyle: HeaderStyle(
                              titleCentered: true,
                              formatButtonVisible: false,
                              titleTextStyle: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            // leftChevronIcon: Container(
                            //   padding: EdgeInsets.all(4),
                            //     decoration: BoxDecoration(color: Colors.amber,shape: BoxShape.circle),
                            //     child: Icon(Icons.arrow_back)), // Customize the previous button
                            // rightChevronIcon: Icon(Icons.arrow_forward),
                          ),
                          calendarBuilders: CalendarBuilders(
                              dowBuilder: (context, dayOfWeek) {
                            return Center(
                              child: Container(
                                width: 40,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade100,
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.all(6),
                                child: Text(
                                  DateFormat.E()
                                      .format(dayOfWeek)
                                      .substring(0, 3),
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.mukta(
                                      color: MyColors.darkGreen,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1),
                                ),
                              ),
                            );
                          }),
                          calendarStyle: CalendarStyle(
                              // rowDecoration: BoxDecoration(
                              //     color: Colors.white
                              // ),
                              defaultDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white60,
                              ),
                              outsideDecoration: BoxDecoration(
                                color: Colors.white60,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              weekendDecoration: BoxDecoration(
                                color: Colors.red.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              todayDecoration: BoxDecoration(
                                color: Colors.green.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              weekendTextStyle:
                                  const TextStyle(color: Colors.red),
                              selectedDecoration: BoxDecoration(
                                color: MyColors.darkGreen,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              outsideDaysVisible: false),
                        ),
                      ),
                    ),
                    Consumer<Matchdate>(
                      builder: (context, md, _) {
                        List<DocumentSnapshot<Map<String, dynamic>>> meals = snapshot.data!.docs.where((meal) {
                          String? mealDate = meal.get("create_time");
                          return mealDate != null && mealDate == dateFormat.format(_focusDay).toString();
                        }).toList();
                        print('Current User ID: $currentUserId');

                        if (meals.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.all(28.0),
                            child: Center(
                              child: Text(
                                "Meal not added yet",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                            ),
                          );
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: SlideTransition(
                            position: _listAnimation,
                            child: ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              itemCount: snapshot.data!.docs.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                String d = dateFormat.format(_focusDay);
                                String firebaseDate = snapshot.data!.docs[index].get("create_time")?.toString() ?? "";
                                print("Data  $firebaseDate");

                                return d == snapshot.data!.docs[index].get("create_time").toString()
                                    ? Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  child: Card(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        gradient: LinearGradient(
                                          colors: [
                                            Theme.of(context).brightness == Brightness.light ? const Color(0xFFacd8a7).withOpacity(0.4) : Colors.black45,
                                            Theme.of(context).brightness == Brightness.light ? const Color(0xFFacd8a7).withOpacity(0.4) : Colors.black45,
                                            Theme.of(context).brightness == Brightness.light ? Colors.green.shade300 : Colors.black54,
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(left: 9.0, top: 5),
                                                child: Row(
                                                  children: [

                                                    Text(
                                                      "${snapshot.data!.docs[index].get("category")}",
                                                      style: GoogleFonts.amiri(
                                                        textStyle: TextStyle(
                                                          color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, right: 5),
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        openDialogBox(
                                                          id: snapshot.data!.docs[index].id,
                                                          category: snapshot.data!.docs[index].get("category"),
                                                          mealName: snapshot.data!.docs[index].get("meal_name"),
                                                        );
                                                      },
                                                      child: Image.asset(
                                                        "assets/edit.png",
                                                        height: 35,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    InkWell(
                                                      onTap: () {
                                                        deleteDialogBox(snapshot.data!.docs[index].id);
                                                      },
                                                      child: Image.asset(
                                                        "assets/bin.png",
                                                        height: 35,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      height: 65,
                                                      width: 65,
                                                      decoration: BoxDecoration(
                                                        color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff).withOpacity(.4),
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(12.0),
                                                        child: snapshot.data!.docs[index].get("category") == "Breakfast"
                                                            ? Image.asset('assets/breakfast.png')
                                                            : snapshot.data!.docs[index].get("category") == "Lunch"
                                                            ? Image.asset("assets/forlunch.png")
                                                            : snapshot.data!.docs[index].get("category") == "Dinner"
                                                            ? Image.asset("assets/fordinner.png")
                                                            : snapshot.data!.docs[index].get("category") == "Dessert"
                                                            ? Image.asset("assets/fordessert.png")
                                                            : snapshot.data!.docs[index].get("category") == "Snacks"
                                                            ? Image.asset("assets/Anything.png")
                                                            : Image.asset("assets/forsnacks.png"),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(
                                                      "Meal : ${snapshot.data!.docs[index].get("meal_name")}",
                                                      style: GoogleFonts.amiri(
                                                        textStyle: TextStyle(
                                                          color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon: Image.asset(
                                                    "assets/arrow-right.png",
                                                    height: 20,
                                                    color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ),
                                ) : const SizedBox();
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(6.0),
        child: FloatingActionButton.extended(
          elevation: 10,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddMealScreen()));
          },
          backgroundColor: MyColors.darkGreen,
          label: const Icon(
            Icons.add,
            size: 27,
          ),
        ),
      ),
    );
  }

  Widget textStryle(String data) {
    return Text(data,
        style: GoogleFonts.kalam(
          textStyle: const TextStyle(
              color: MyColors.darkGreen,
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ));
  }

  openDialogBox({id, category, mealName}) {
    mealNameController.text = mealName;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Update Meal",
                style: GoogleFonts.kalam(
                  textStyle: const TextStyle(
                      color: MyColors.darkGreen,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Category: $category",
                    style: GoogleFonts.kalam(
                      textStyle: const TextStyle(
                          color: MyColors.darkGreen,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: mealNameController,
                  cursorColor: MyColors.darkGreen,
                  decoration: InputDecoration(
                    hintText: "Enter Meal",
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    filled: true,
                    fillColor: Colors.green.withOpacity(0.6),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: MyColors.green),
                        borderRadius: BorderRadius.circular(10)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: MyColors.green),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
            actions: [
              MaterialButton(
                child: const Text('Update'),
                onPressed: () {
                  updateMeal(id);
                },
              ),
            ],
          );
        });
  }

  deleteDialogBox(String id) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: Text("Are you sure you want to delete?",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kalam(
                    textStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  )),
            ),
            actions: [
              TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold),
                  )),
              TextButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.green.shade100),
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection("addMealData")
                        .doc(id)
                        .delete()
                        .then((value) => Navigator.pop(context));
                  },
                  child: const Text(
                    "Yes",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.bold),
                  )),
            ],
          );
        });
  }
}
