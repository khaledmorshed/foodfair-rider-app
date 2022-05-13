class Sellers {
  String? sellerUID;
  String? sellerName;
  String? sellerAvatarUrl;
  String? sellerEmail;
  String? address;

  Sellers(
      {this.sellerUID,
      this.sellerName,
      this.sellerAvatarUrl,
      this.sellerEmail,
      this.address});

  Sellers.frmJson(Map<String, dynamic>? jsonValue) {
    sellerUID = jsonValue!["sellerUID"];
    sellerName = jsonValue["sellerName"];
    sellerAvatarUrl = jsonValue["sellerAvatarUrl"];
    sellerEmail = jsonValue["sellerEmail"];
    address = jsonValue["address"];
  }

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic>? data = <String, dynamic>{};
    data!["sellerUID"] = sellerUID;
    data["sellerName"] = sellerName;
    data["sellerEmail"] = sellerEmail;
    data["sellerAvatarUrl"] = sellerAvatarUrl;
    data["address"] = address;
    return data;
  }
}
