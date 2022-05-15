import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../global/current_location.dart';
import '../global/global_instance_or_variable.dart';
import '../map/map_utils.dart';
import 'parcel_delivering_screen.dart';

class ParcelPickingScreen extends StatefulWidget {
  String? purchaserID;
  String? sellerID;
  String? orderID;
  String? purchaserAddress;
  double? purchaserLatitude;
  double? purchaserLongitude;

  ParcelPickingScreen({
    Key? key,
    this.purchaserID,
    this.sellerID,
    this.orderID,
    this.purchaserAddress,
    this.purchaserLatitude,
    this.purchaserLongitude,
  }) : super(key: key);

  @override
  _ParcelPickingScreenState createState() => _ParcelPickingScreenState();
}

class _ParcelPickingScreenState extends State<ParcelPickingScreen> {
  double? sellerLatitude, sellerLongitude;

  getSellerData() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .doc(widget.sellerID)
        .get()
        .then((DocumentSnapshot) {
      sellerLatitude = DocumentSnapshot.data()!["latitude"];
      sellerLongitude = DocumentSnapshot.data()!["longitude"];
    });
  }

  @override
  void initState() {
    super.initState();

    getSellerData();
  }

  confirmParcelHasBeenPickedFromSeller(orderId, sellerId, purchaserId,
      purchaserAddress, purchaserLatitude, purchaserLongitude) {
    FirebaseFirestore.instance.collection("orders").doc(orderId).update({
      "status": "delivering",
      "riderCurrentAddress": completeAddress,
      "latitude": position!.latitude,
      "longitude": position!.longitude,
    });

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (c) => ParcelDeliveringScreen(
                  purchaserId: purchaserId,
                  purchaserAddress: purchaserAddress,
                  purchaserLatitude: purchaserLatitude,
                  purchaserLongitude: purchaserLongitude,
                  sellerId: sellerId,
                  orderId: orderId,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("parcel pickig screen")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Congratulation. You got a parcel",
            style: TextStyle(
              // fontFamily: "Signatra",
              fontSize: 18,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Image.asset(
            "assets/images/confirm1.png",
            width: 350,
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onTap: () {
              //show location from rider current location to seller location
              MapUtils.launchMapFromSourceToDestination(position!.latitude,
                  position!.longitude, sellerLatitude, sellerLongitude);
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
                      "Show Cafe/Restaurant Location",
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
                  confirmParcelHasBeenPickedFromSeller(
                    widget.orderID,
                    widget.sellerID,
                    widget.purchaserID,
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
                      "Order has been Picked from seller- Confirmed",
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
