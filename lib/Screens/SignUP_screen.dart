import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_tracker_app/Models/Colors.dart';
import 'package:meal_tracker_app/Screens/Login_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUPScreen extends StatefulWidget {
  const SignUPScreen({Key? key}) : super(key: key);

  @override
  State<SignUPScreen> createState() => _SignUPScreenState();
}

class _SignUPScreenState extends State<SignUPScreen> {
  final _formKey = GlobalKey<FormState>();
  bool passToggle = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();



  Future<void> registration() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((_) {
        Fluttertoast.showToast(
          msg: "Registration successfully,Please Login",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor:MyColors.darkGreen,
          textColor: Colors.white,
        );
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
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
                      const Text("Already have an account ? ",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text("Login",
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0),
                    child: Container(
                      child: Column(
                        children: [
                          Lottie.asset('assets/signup.json', height: 180)
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(
                      "Sign Up",
                      style: GoogleFonts.sigmarOne(
                          textStyle: const TextStyle(
                              color: MyColors.green, fontSize: 30)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 250.0, bottom: 5),
                          child: Text(
                            "Name",
                            style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ),
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter your name";
                            }
                            return null;
                          },
                          cursorColor: MyColors.darkGreen,
                          decoration: InputDecoration(
                              hintText: "Enter your name",
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 20.0),
                              filled: true,
                              fillColor: Colors.green.withOpacity(0.5),
                              border: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: MyColors.green),
                                  borderRadius: BorderRadius.circular(30)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: MyColors.green),
                                  borderRadius: BorderRadius.circular(30)),
                              suffixIcon:  Icon(
                                Icons.person_2_outlined,
                                color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
                              )),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(right: 210.0, bottom: 5),
                          child: Text(
                            "Email Address",
                            style: TextStyle(
                                color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen :Colors.white,
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
                              fillColor: Colors.green.withOpacity(0.5),
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
                        const SizedBox(height: 20),
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
                              fillColor: Colors.green.withOpacity(0.5),
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
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () async{
                            if (_formKey.currentState!.validate()) {
                              var prefs = await SharedPreferences.getInstance();
                              prefs.setString('myName', nameController.text.toString());
                              registration();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Please fill all detail",
                                  backgroundColor: Colors.redAccent);
                            }
                            // var name = nameController.text.toString();


                          },
                          child: Text(
                            'Sign up',
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
          )),
    );
  }


}
