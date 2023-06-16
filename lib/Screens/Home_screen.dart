import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meal_tracker_app/Models/Colors.dart';
import 'package:meal_tracker_app/Screens/ProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Models/CardList.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool showWidget = false;
  var nameValue = "";

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  @override
  void initState() {
    repeatOnce();
    getValue();
    super.initState();
  }

  void repeatOnce() async {
    await _controller.forward();
    await _controller.reverse();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void getValue() async{
    var prefs = await SharedPreferences.getInstance();
    var getName = prefs.getString('myName');
    if(getName != null){
      setState(() {
        nameValue = getName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        // toolbarHeight: 100,
        elevation: 0,
        centerTitle: true,
        backgroundColor:Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).scaffoldBackgroundColor,
        iconTheme: const IconThemeData(color: MyColors.darkGreen),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Hello $nameValue",style:  GoogleFonts.anekOdia(
                textStyle:  TextStyle(
                    color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,

                    fontSize: 28,
                    fontWeight: FontWeight.bold))),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen(),));
                },
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset("assets/pretty.jpg",height: 40,width: 40,fit: BoxFit.cover,))
            ),
          ],
        ),

      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("New Dishes",style:  GoogleFonts.mukta(
                    textStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold))),
                const SizedBox(width: 5,),
                Image.asset("assets/maindish.png",height: 25,width: 25,)
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: listOfCards.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: const EdgeInsets.all(8.0),
                    height: 180,
                    child: Card(
                      elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      color:Theme.of(context).brightness == Brightness.light ? Colors.green.shade50 : Theme.of(context).cardColor ,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text(listOfCards[index].title,style: TextStyle(color:Theme.of(context).brightness == Brightness.light ? MyColors.darkGreen : Colors.white,
                                    fontSize: 18,fontWeight: FontWeight.w700,
                                  ),),
                                  const SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      Text(listOfCards[index].icon+listOfCards[index].ret,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white60,
                                      fontSize: 15,fontWeight: FontWeight.w500)),
                                      Text(listOfCards[index].calories,style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black54 : Colors.white54,fontSize: 12,)),
                                    ],
                                  ),
                                const SizedBox(height: 28,),
                                TextButton(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)
                                    )),
                                    backgroundColor: MaterialStateProperty.all(Colors.green.shade100),
                                  ),
                                    onPressed: null, child:const Text("45 MIN",style: TextStyle(color: Colors.black45),))

                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                                child: Image.asset(listOfCards[index].img,height: 100,width: 100,fit: BoxFit.cover,))
                          ],
                        ),
                      ) 

                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

}
