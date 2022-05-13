import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'global_instance_or_variable.dart';


//here we sepate items id from items collection
separateItemsIdFromUserCartList() {
  List<String> separateItemsIdsList = [], getPreviouslySavedItemsList = [];
  getPreviouslySavedItemsList = sPref!.getStringList("userCart")!;

  for (int i = 0; i < getPreviouslySavedItemsList.length; i++) {
    //here inside of items itemsID and qunatity of item are assigned like("1650134716838673:2")
    String item = getPreviouslySavedItemsList[i].toString();
    //we extract itemsID(1650134716838673) from "1650134716838673:2" here by item.lastIndexOf(":")
    var pos = item.lastIndexOf(":");
    String getItemID = (pos != -1) ? item.substring(0, pos) : item;
    separateItemsIdsList.add(getItemID);
  }
  return separateItemsIdsList;
}

//here we separate order ids from order collection
separateItemIDFromOrdersCollection(prouctIds) {
  List<String> separateItemsIdsList = [];
  List<String> productIdsList = [];
  //here we have itemList
  // getPreviouslySavedItemsList = List<String>.from(prouctIds);
  productIdsList = List<String>.from(prouctIds);
  //productIdsList = prouctIds == null ? [] : List<String>.from(prouctIds);

  for (int i = 0; i < productIdsList.length; i++) {
    //here inside of item itemsID and qunatity of item are assigned like("1650134716838673:2")
    String item = productIdsList[i].toString();
    //we extract itemsID(1650134716838673) from "1650134716838673:2" here by item.lastIndexOf(":")
    var pos = item.lastIndexOf(":");
    String getItemID = (pos != -1) ? item.substring(0, pos) : item;
    separateItemsIdsList.add(getItemID);
  }
  return separateItemsIdsList;
}


separateItemsQuantityFromUserCartList() {
  List<int> separateItemsQuantityList = [];
  List<String> getPreviouslySavedItemsList = sPref!.getStringList("userCart")!;

  //here indext start from 1 because inside of 0the indext we have garbase value
  for (int i = 1; i < getPreviouslySavedItemsList.length; i++) {
    //here inside of item itemsID and qunatity of item are assigned like("1650134716838673:2")
    String item = getPreviouslySavedItemsList[i].toString();

    //(1650134716838673:2)here simply mean that 0th index has : and 1th index has 2.
    List<String> listItemCharacters = item.split(":").toList();
    //here we get the 2 inside of quantityNumber
    var quantityNumber = int.parse(listItemCharacters[1].toString());
    separateItemsQuantityList.add(quantityNumber);
  }
  return separateItemsQuantityList;
}

//here we separate item quantiy from order colleciton
separateItemQuantityFromOrdersCollection(prouctIds) {
  List<String> separateItemsQuantityList = [];
  List<String> productIdList = [];
  // productIdList = List<String>.from(prouctIds);

  productIdList = List<String>.from(prouctIds);
  //productIdList = prouctIds == null ? [] : List<String>.from(prouctIds);

  //here indext start from 1 because inside of 0the indext we have garbase value
  for (int i = 1; i < productIdList.length; i++) {
    //here inside of item itemsID and qunatity of item are assigned like("1650134716838673:2")
    String item = productIdList[i].toString();

    //(1650134716838673:2)here simply mean that 0th index has : and 1th index has 2.
    List<String> listItemCharacters = item.split(":").toList();
    //here we get the 2 inside of quantityNumber
    var quantityNumber = int.parse(listItemCharacters[1].toString());
    separateItemsQuantityList.add(quantityNumber.toString());
  }
  return separateItemsQuantityList;
}

clearCart(context) {
  //so now cart has only one value in 0the index which value is garbageValue
  sPref!.setStringList("userCart", ['garbageValue']);
  //now get that only one value inside of emptyList
  List<String>? emptyList = sPref!.getStringList("userCart");
  //now this emptyList set into firebaseFirestore
  FirebaseFirestore.instance
      .collection("users")
      .doc(firebaseAuth.currentUser!.uid)
      .update({"userCart": emptyList}).then((value) {
    //now set it locally empyt aslo
    sPref!.setStringList("userCart", emptyList!);
    //now shopping cart need to set 0
    // Provider.of<CartItemQuanityProvider>(context, listen: false)
    //     .displayCartItemNumber();
    // Navigator.push(
    //     context, MaterialPageRoute(builder: (context) => UserHomeScreen()));
  });
}

