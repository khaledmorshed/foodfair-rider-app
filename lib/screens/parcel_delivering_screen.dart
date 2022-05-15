import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair_rider_app/screens/rider_home_screen.dart';

import '../global/current_location.dart';
import '../global/global_instance_or_variable.dart';
import '../map/map_utils.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  String? purchaserId;
  String? purchaserAddress;
  double? purchaserLatitude;
  double? purchaserLongitude;
  String? sellerId;
  String? orderId;

  ParcelDeliveringScreen({
    Key? key,
    this.purchaserId,
    this.purchaserAddress,
    this.purchaserLatitude,
    this.purchaserLongitude,
    this.sellerId,
    this.orderId,
  }) : super(key: key);

  @override
  State<ParcelDeliveringScreen> createState() => _ParcelDeliveringScreenState();
}

class _ParcelDeliveringScreenState extends State<ParcelDeliveringScreen> {
  String orderTotalAmount = "";

  String riderNewTotalEarnigsAmount = ((double.parse(previousRiderEarnigs)) +
          double.parse(perParcelDeliveryAmount))
      .toString();

  //when parcel will be provide to user then all these will update
  confirmParcelHasBeenDeliveredToPurchaser(orderId, sellerId, purchaserId,
      purchaserAddress, purchaserLatitude, purchaserLongitude) {
    FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "ended",
      "riderCurrentAddress": completeAddress, //rider
      "latitude": position!.latitude, //rider
      "longitude": position!.longitude, //rider
      // "earnings": perParcelDeliveryAmount, //pay per delivery
    }).then((value) {
      //upadate rider earnings
      FirebaseFirestore.instance
          .collection("riders")
          .doc(sPref!.getString("uid"))
          .update({
        "earnings": riderNewTotalEarnigsAmount, //total eranigs of rider
      });
    }).then((value) {
      //seller
      print(
          "SellerId = ${widget.sellerId} + SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSss");
      double prevEar = double.parse(previousSellerEarnigs);
      String sellerNewTotalEarnigsAmount =
          ((double.parse(orderTotalAmount)) + prevEar).toString();
      //update seller earnings
      FirebaseFirestore.instance
          .collection("sellers")
          .doc(widget.sellerId)
          .update({
        "earnings": sellerNewTotalEarnigsAmount, //total eranigs of seller
      });
    }).then((value) {
      print(
          "userID = $purchaserId + UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU");
      //updating user order sections
      FirebaseFirestore.instance
          .collection("users")
          .doc(purchaserId)
          .collection("orders")
          .doc(orderId)
          .update({
        "status": "ended",
        "riderUID": sPref!.getString("uid"),
      });
    });

    Navigator.push(
        context, MaterialPageRoute(builder: (c) => RiderHomeScreen()));
  }

  //getting total amount of per order for specific order
  getTotalAmountFromOrder() {
    //here we get the specific order details with widget.orderId
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .get()
        .then((snap) {
      orderTotalAmount = snap.data()!["totalAmount"].toString();
      print(
          "orderTotalAmount = $orderTotalAmount + BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBbbb");
      //just for confirmation sellerUID. Though it may not necessay
      widget.sellerId = snap.data()!["sellerUID"].toString();
    }).then((value) {
      getSellerData();
    });
  }

  //get seller data for updating earnigs
  getSellerData() {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerId)
        .get()
        .then((snap) {
      //this earnigs come from seller earnigs from firebase
      previousSellerEarnigs = snap.data()!["earnings"].toString();
      print(
          "previousSellerEarnigs = $previousSellerEarnigs + AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAaaa");
    });
  }

  @override
  void initState() {
    super.initState();

    //it will update the rider current location
    RiderLocation uLocation = RiderLocation();
    uLocation.getCurrentLocation();

    getTotalAmountFromOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Parcel Delivering Screen")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/confirm2.png",
            width: 350,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              //show location from rider current location to purchaser(user) location
              MapUtils.launchMapFromSourceToDestination(
                  position!.latitude,
                  position!.longitude,
                  widget.purchaserLatitude,
                  widget.purchaserLongitude);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/restaurant.png',
                  width: 50,
                ),
                const SizedBox(
                  width: 7,
                ),
                Column(
                  children: const [
                    SizedBox(
                      height: 12,
                    ),
                    Text(
                      "Show Purchaser  Location",
                      style: TextStyle(
                        //fontFamily: "Signatra",
                        fontSize: 18,
                        //letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: InkWell(
                onTap: () {
                  //it will update the rider current location
                  RiderLocation uLocation = RiderLocation();
                  uLocation.getCurrentLocation();

                  //confirmed - that rider has picked parcel from seller
                  confirmParcelHasBeenDeliveredToPurchaser(
                    widget.orderId,
                    widget.sellerId,
                    widget.purchaserId,
                    widget.purchaserAddress,
                    widget.purchaserLatitude,
                    widget.purchaserLongitude,
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                    colors: [
                      Colors.cyan,
                      Colors.amber,
                    ],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp,
                  )),
                  width: MediaQuery.of(context).size.width - 10,
                  height: 50,
                  child: const Center(
                    child: Text(
                      "Order has been delivered to purchaser - Confirm",
                      style: TextStyle(color: Colors.white, fontSize: 15.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
