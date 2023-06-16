class CardList {
  final String title;
  final String icon;
  final String ret;
  final String calories;
  final String img;


  CardList({required this.img,required this.ret,required this.icon,required this.calories, required this.title});
}

List<CardList> listOfCards = [

  CardList(
    img : "assets/cauliflower tacos.jpg",
    icon: " 👌 ",
    ret: "4.63",
    calories: "(232)",
    title: "Cauliflower Tacos",
  ),
  CardList(
    img : "assets/mexican potatoes.webp",
    icon: " 🔥 ",
    ret: "5.83",
    calories: "(270)",
    title: "Maxican Potatoes",
  ),
  CardList(
    img : "assets/mexican veg dips.jpg",
    icon: " 👌 ",
    calories: "(432)",
    ret: "6.23",
    title: "Maxican Veg Dips",

  ),
  CardList(
    img : "assets/guacamole.jpg",
    icon: " 🔥 ",
    ret: "5.21",
    calories: "(262)",
    title: "Guacamola",

  ),
  CardList(
    img : "assets/Black bean Dip.jpg",
    ret: "4.20",
    calories: "(270)",
    icon: " 👌 ",
    title: "Black bean Dip",

  ),

  CardList(
    img : "assets/maxican baritos.jpg",
    icon: " 🔥 ",
    ret: "5.93",
    calories: "(330)",
    title: "Maxicon Barritos",

  ),

  CardList(
    img : "assets/Vegan-Fajitas.jpg",
    icon: " 👌 ",
    ret: "6.34",
    calories: "(260)",
    title: "Vegan Fajitas",

  ),

  CardList(
    img : "assets/maxicon street corn.jpg",
    icon:  " 🔥 ",
    ret: "4.67",
    calories: "(370)",
    title: "Maxican Street Corn",

  ),

  CardList(
    img : "assets/Mexican coleslaw.jpg",
    icon:  " 👌 ",
    ret: "5.34",
    calories: "(578)",
    title: "Mexican coleslaw",

  ),

  CardList(
    img : "assets/maxicon nachos.jpeg",
    icon:  " 🔥 ",
    ret: "4.67",
    calories: "(645)",
    title: "Maxicon vegan nachos",

  ),


];
