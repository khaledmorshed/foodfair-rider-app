import 'package:cloud_firestore/cloud_firestore.dart';

class Menus
{
  String? menuID;
  String? sellerUID;
  String? menuTitle;
  String? menuShortInformation;
  Timestamp? publishedDate;
  String? menuImageUrl;
  String? status;

  Menus({
    this.menuID,
    this.sellerUID,
    this.menuTitle,
    this.menuShortInformation,
    this.publishedDate,
    this.menuImageUrl,
    this.status,
  });

  Menus.fromJson(Map<String, dynamic> json)
  {
    menuID = json["menuID"];
    sellerUID = json['sellerUID'];
    menuTitle = json['menuTitle'];
    menuShortInformation = json['menuShortInformation'];
    publishedDate = json['publishedDate'];
    menuImageUrl = json['menuImageUrl'];
    status = json['status'];
  }

  Map<String, dynamic> toJson()
  {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data['sellerUID'] = sellerUID;
    data['menuTitle'] = menuTitle;
    data['menuShortInformation'] = menuShortInformation;
    data['publishedDate'] = publishedDate;
    data['menuImageUrl'] = menuImageUrl;
    data['status'] = status;

    return data;
  }
}