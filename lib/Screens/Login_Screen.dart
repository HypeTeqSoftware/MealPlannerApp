import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_tracker_app/Models/Colors.dart';
import 'package:meal_tracker_app/Screens/NavBarRoots.dart';
import 'package:meal_tracker_app/Screens/SignUP_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var email = "";
  var password = "";
  bool passToggle = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Fluttertoast.showToast(
          msg: "Login successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:MyColors.darkGreen,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavBarRoots(),
            ));
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: MyColors.darkGreen,
          content: Text(
            e.code,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? Colors.yellow.shade50 :Colors.black,
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage('assets/bg.png'),
        ),
      ),
      child: Scaffold(
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(40), topRight: Radius.circular(40)),
            child: BottomAppBar(
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.green.shade400,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  height: 65,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have any account ? ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUPScreen(),
                              ));
                        },
                        child: const Text("Sign up",
                            style: TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      )
                    ],
                  )),
            ),
          ),
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        child: Image.asset(
                      'assets/foodicon.png',
                      height: 100,
                    )),
                    const SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Login",
                        style: GoogleFonts.sigmarOne(
                            textStyle: const TextStyle(
                                color: MyColors.green, fontSize: 30)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                           Padding(
                            padding: const EdgeInsets.only(right: 210.0, bottom: 5),
                            child: Text(
                              "Email Address",
                              style: TextStyle(
                                  color:Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          TextFormField(
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter email address";
                              } else if (!value.contains("@")) {
                                return "Please Enter Valid Email";
                              } else if (!value.contains(".com")) {
                                return "Please Enter Valid Email";
                              }
                              return null;
                            },
                            cursorColor: MyColors.darkGreen,
                            decoration: InputDecoration(
                                hintText: "Enter your email",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                filled: true,
                                fillColor: Colors.green.withOpacity(0.6),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: MyColors.green),
                                    borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: MyColors.green),
                                    borderRadius: BorderRadius.circular(30)),
                                suffixIcon:  Icon(
                                  Icons.email_outlined,
                                  color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                                )),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                           Padding(
                            padding: const EdgeInsets.only(right: 240.0, bottom: 5),
                            child: Text(
                              "Password",
                              style: TextStyle(
                                  color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                          TextFormField(
                            controller: passwordController,
                            obscureText: passToggle,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter Password";
                              } else if (value.length < 6) {
                                return "Please enter at least 6 digit";
                              }
                              return null;
                            },
                            cursorColor: MyColors.darkGreen,
                            decoration: InputDecoration(
                                hintText: "Enter Password",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15.0, horizontal: 20.0),
                                filled: true,
                                fillColor: Colors.green.withOpacity(0.6),
                                border: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: MyColors.green),
                                    borderRadius: BorderRadius.circular(30)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        const BorderSide(color: MyColors.green),
                                    borderRadius: BorderRadius.circular(30)),
                                suffixIcon: InkWell(
                                  onTap: (){
                                    setState(() {
                                      passToggle =! passToggle;
                                    });
                                  },
                                  child:Icon(
                                    passToggle ? Icons.visibility: Icons.visibility_off,color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                                  ),
                                )),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              minimumSize: const Size(200, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    30),
                              ),
                            ),
                            onPressed: () async{
                              if (_formKey.currentState!.validate()) {
                                var pref = await SharedPreferences.getInstance();
                                pref.setBool("Login", true);
                                setState(() {
                                  email = emailController.text;
                                  password = passwordController.text;
                                });
                                userLogin();
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Please fill all detail",
                                    backgroundColor: Colors.redAccent);
                              }
                            },
                            child: Text(
                              'Login',
                              style: GoogleFonts.sigmarOne(
                                  textStyle: const TextStyle(
                                      color: Colors.white, fontSize: 20)),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
}
