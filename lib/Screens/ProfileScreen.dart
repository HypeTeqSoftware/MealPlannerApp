import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_tracker_app/Models/Colors.dart';
import 'package:meal_tracker_app/Screens/Login_Screen.dart';
import 'package:meal_tracker_app/Screens/ProfileImagePickerScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  var newPassword = "";
  var editEmail = "";
  var nameValue = "";
  bool passToggle = true;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();

  void signOutUser() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? currentUser = auth.currentUser;
    if(currentUser != null){
      try{
        await currentUser.delete().then((value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen(),)));
      }on FirebaseAuthException catch(e){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
            e.code,
            style: const TextStyle(fontSize: 18.0),
    ),),);
      }
    }
  }

  @override
  void initState() {
    getValue();
    super.initState();
  }

  void changePassword() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    try{
      await currentUser!.updatePassword(newPasswordController.text).then((value) {
        {
          Fluttertoast.showToast(
            msg: "Password Changed,Please Login",
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
        }
      });
    }on FirebaseException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        e.code,
        style: const TextStyle(fontSize: 18.0),
      ),),);
    }


  }
  void changeEmail() async{
    final currentUser = FirebaseAuth.instance.currentUser;
    try{
      await currentUser!.updateEmail(emailController.text).then((value) {
        {
          Fluttertoast.showToast(
            msg: "Email Changed,Please Login",
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
        }
      });
    }on FirebaseException catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(
        e.code,
        style: const TextStyle(fontSize: 18.0),
      ),),);
    }


  }
  _launchURL() async {
    var url = Uri.parse("https://hypeteq.com/");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void getValue() async{
    var prefs = await SharedPreferences.getInstance();
    var getName = prefs.getString('myName');
    setState(() {
      nameValue = getName ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 280,
                  decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.green.shade300 : Colors.black45,
                      borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30))
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.pop(context);
                              }, icon: const Icon(Icons.arrow_back_ios_new,color: Colors.white,size: 20,)),
                              const Text("Profile",style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold
                              ),),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const ProfileImagePickerScreen(),
                    const SizedBox(height: 5),
                    Text(nameValue,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,fontSize: 16,fontWeight: FontWeight.bold),),
                    const SizedBox(height: 5),
                  ],
                )
              ]
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                InkWell(
                  onTap: (){
                    editEmailDialog(email: FirebaseAuth.instance.currentUser!.email.toString());
                  },
                    child: drawerText("Change Email", Icons.lock_open_outlined)),
                  InkWell(
                    onTap: (){
                      editPasswordDialog();
                    },
                      child: drawerText("Change Password", Icons.change_circle_outlined)),
                InkWell(
                  onTap: (){
                    infoDialogBox();
                  },
                    child: drawerText("Information", Icons.perm_device_information)),
                InkWell(
                  onTap: () => signOutUser(),
                    child: drawerText("Sign Out", Icons.logout_rounded)),
              ],
            )
          ],
        ),
      ),
    );
  }
  Widget drawerText(String name,IconData icons) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        color: Colors.grey.withOpacity(0.2),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Stack(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration:
                      BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(20), //<-- SEE HERE
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 13,vertical: 12),
                      child: Icon(icons,color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white60,),
                    )
                  ]
              ),
            ),
            Text(name,style: const TextStyle(fontWeight: FontWeight.w500),)

          ],
        ),
      ),
    );

  }

  infoDialogBox(){
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text("Infomation",
                style: GoogleFonts.muktaMahee(
                  textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    ClipOval(child: Image.asset("assets/hypeteq.jfif",height: 60,width: 70,)),
                    const SizedBox(width: 10,),
                    Flexible(child: Text("Hypeteq software solutions pvt. ltd",style:GoogleFonts.mukta(textStyle: TextStyle(fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen: Colors.white,
                    )) ))
                  ],
                ) ,
                const SizedBox(height: 10,),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Visit: ",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen: Colors.white,)),
                      InkWell(
                        onTap: (){
                          _launchURL();
                        },
                          child: const Text("hypeteq.com",style: TextStyle(color: Colors.blueAccent,decoration: TextDecoration.underline,fontWeight: FontWeight.bold),)),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  editEmailDialog({required String email}){
    editEmail = emailController.text;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30)
            ),
            title: Text("Edit Data",
                style: GoogleFonts.kalam(
                  textStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(height: 10,),

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
                    hintText: FirebaseAuth.instance.currentUser!.email ?? 'Email',
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
                child: const Text('Edit Email'),
                onPressed: () {
                  changeEmail();
                },
              ),
            ],
          );
        });
  }

  editPasswordDialog(){
    newPassword = newPasswordController.text;
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context,setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)
                  ),
                  title: Text("Change Password",
                      style: GoogleFonts.kalam(
                        textStyle: TextStyle(
                            color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: newPasswordController,
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
                          hintText:"Change Password",
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
                            suffixIcon: InkWell(
                              onTap: (){
                                setState(() {
                                  passToggle =! passToggle;
                                });
                              },
                              child:Icon(
                                passToggle ? Icons.visibility: Icons.visibility_off,color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen: Colors.white,
                              ),
                            )
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      child: const Text('Change Password'),
                      onPressed: (){
                       changePassword();
                      },
                    ),
                  ],
                );
              }
            );
          });
  }
}
