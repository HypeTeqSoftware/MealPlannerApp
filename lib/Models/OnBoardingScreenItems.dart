class Items {
  final String img;
  final String title;
  final String subTitle;

  Items({
    required this.img,
    required this.title,
    required this.subTitle,
  });
}


List<Items> listOfItems = [

  Items(
    img : "assets/girlwithfood.json",
    title: "Personalize your Daily Meal Plans",
    subTitle: "We help you in your diet,\n pleasure of variety.",
  ),
  Items(
    img : "assets/healthyfood.json",
    title: "Healthy Meal for \n Everyone",
    subTitle: "We help you to choose \n healthy meal for your diet.",
  ),
  Items(
    img : "assets/burgur.json",
    title: "Meal Planner",
    subTitle: "Let's plan your perfect meal!!",
  ),
];

