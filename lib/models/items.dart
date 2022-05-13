import 'package:cloud_firestore/cloud_firestore.dart';

class Items {
  String? menuID;
  String? itemID;
  String? sellerUID;
  String? shortInformation;
  String? itemTitle;
  String? itemDescription;
  double? price;
  Timestamp? publishedDate;
  String? status;
  String? itemImageUrl;

  Items({
    this.menuID,
    this.itemID,
    this.sellerUID,
    this.shortInformation,
    this.itemTitle,
    this.itemDescription,
    this.price,
    this.publishedDate,
    this.status,
    this.itemImageUrl,
  });

  Items.fromJson(Map<String, dynamic> json) {
    menuID = json['menuID'];
    itemID = json['itemID'];
    sellerUID = json['sellerUID'];
    shortInformation = json['shortInformation'];
    itemTitle = json['itemTitle'];
    itemDescription = json['itemDescription'];
    price = json['price'];
    publishedDate = json['publishedDate'];
    status = json['status'];
    itemImageUrl = json['itemImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["menuID"] = menuID;
    data["itemID"] = itemID;
    data["sellerUID"] = sellerUID;
    data["shortInformation"] = shortInformation;
    data["itemTitle"] = itemTitle;
    data["itemDescription"] = itemDescription;
    data['price'] = price;
    data["publishedDate"] = publishedDate;
    data["status"] = status;
    data["itemImageUrl"] = itemImageUrl;

    return data;
  }
}
