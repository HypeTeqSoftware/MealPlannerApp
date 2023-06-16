import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:meal_tracker_app/Models/OnBoardingScreenItems.dart';
import 'package:meal_tracker_app/Screens/SignUP_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class On_Boarding_screen extends StatefulWidget {
  const On_Boarding_screen({Key? key}) : super(key: key);

  @override
  State<On_Boarding_screen> createState() => _On_Boarding_screenState();
}

class  _On_Boarding_screenState extends State<On_Boarding_screen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage('assets/background.jpg'),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 1.4,
                    width: MediaQuery.of(context).size.width,
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (newIndex) {
                        setState(() {
                          currentIndex = newIndex;
                        });
                      },
                      itemCount: listOfItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            Lottie.asset(listOfItems[index].img, height: 300),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  listOfItems[index].title,
                                  style: GoogleFonts.sigmarOne(
                                      textStyle: const TextStyle(
                                          color: Colors.lightGreenAccent,
                                          fontSize: 28))),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                  textAlign: TextAlign.center,
                                  listOfItems[index].subTitle,
                                  style: GoogleFonts.rumRaisin(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 19,
                                          letterSpacing: 0.7))),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: listOfItems.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 6.0,
                      radius: 10.0,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      expansionFactor: 3.8,
                      dotColor: Colors.grey,
                      activeDotColor: Colors.green,
                    ),
                    onDotClicked: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                        pageController.animateToPage(newIndex,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    },
                  ),
                ],
              ),
              currentIndex == 2
                  ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUPScreen(),
                                ));
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(250, 50)),
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.sigmarOne(
                                textStyle: const TextStyle(
                                    color: Colors.green, fontSize: 22)),
                          ),
                        ),
                        const SizedBox(height: 40)
                      ],
                    )
                  : Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.easeInOut);
                            });
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(250, 50)),
                          ),
                          child: Text(
                            'Skip',
                            style: GoogleFonts.sigmarOne(
                                textStyle: const TextStyle(
                                    color: Colors.green, fontSize: 22)),
                          ),
                        ),
                        const SizedBox(height: 40)
                      ],
                    )
            ],
          ),
        ),
      ),
    );
  }
}
