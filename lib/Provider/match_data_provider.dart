import 'package:flutter/cupertino.dart';

class Matchdate extends ChangeNotifier{
  var datestore;


  storeDate(date){
    datestore = date;
    notifyListeners();
  }

}