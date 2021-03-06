import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:foodfair_rider_app/global/current_location.dart';
import 'package:foodfair_rider_app/global/global_instance_or_variable.dart';
import 'package:foodfair_rider_app/screens/parcel_picking_screen.dart';

import '../models/address.dart';
import '../presentation/color_manager.dart';
import '../screens/parcel_delivering_screen.dart';
import '../screens/rider_home_screen.dart';

class ForPickingWidget extends StatelessWidget {
  final Address? addressModel;
  final String? orderStatus;
  final String? orderID;
  final String? sellerUID;
  final String? orderByUser;
  String? deliveryStatus;

  ForPickingWidget({
    Key? key,
    this.addressModel,
    this.orderStatus,
    this.orderID,
    this.sellerUID,
    this.orderByUser,
    this.deliveryStatus,
  }) : super(key: key);

  confirmParcelShipmentFromSeller(BuildContext context, String orderID,
      String sellerID, String purchaserID) {
    FirebaseFirestore.instance.collection("orders").doc(orderID).update({
      "riderUID": sPref!.getString("uid"),
      "riderName": sPref!.getString("name"),
      "status": "picking",
      "latitude": position!.latitude,
      "longitude": position!.longitude,
      "riderCurrentAddress": completeAddress,
    });

    deliveryStatus == "delivering"
        ? Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ParcelDeliveringScreen(
                      purchaserId: purchaserID,
                      purchaserAddress: addressModel!.fullAddress,
                      purchaserLatitude: addressModel!.latitude,
                      purchaserLongitude: addressModel!.longitude,
                      sellerId: sellerID,
                      orderId: orderID,
                    )))
        : Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => ParcelPickingScreen(
                      purchaserID: purchaserID,
                      purchaserAddress: addressModel!.fullAddress,
                      purchaserLatitude: addressModel!.latitude,
                      purchaserLongitude: addressModel!.longitude,
                      sellerID: sellerID,
                      orderID: orderID,
                    )));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text('Shipping Details:',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(
          height: 6.0,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          //color: Colors.red,
          child: Table(
            //defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            //defaultColumnWidth: FixedColumnWidth(200),

            //it takes size depeneds on text length
            defaultColumnWidth: IntrinsicColumnWidth(),

            // columnWidths: {
            //   0: FixedColumnWidth(150.0), // fixed to 100 width
            //   1: FlexColumnWidth(),
            //   2: FixedColumnWidth(150.0), //fixed to 100 width
            // },
            children: [
              TableRow(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Name",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(addressModel!.name!),
                  ),
                ],
              ),
              TableRow(
                decoration: const BoxDecoration(
                    //color: Colors.green,
                    ),
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Phone Number",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(addressModel!.phoneNumber!),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            addressModel!.fullAddress!,
            textAlign: TextAlign.justify,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: ElevatedButton(
            child: const Text(
              "Go back",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.purple[300],
              padding:
                  const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: ColorManager.depOrange1),
              ),
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => RiderHomeScreen()));
            },
          ),
        ),
        orderStatus == "ended"
            ? Container()
            : Center(
                child: ElevatedButton(
                  child: Text(
                    deliveryStatus == "delivering"
                        ? "go for delivering"
                        : "click to pick this parcel",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.purple[300],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: ColorManager.depOrange1),
                    ),
                  ),
                  onPressed: () {
                    RiderLocation uLocation = RiderLocation();
                    uLocation.getCurrentLocation();
                    confirmParcelShipmentFromSeller(
                        context, orderID!, sellerUID!, orderByUser!);
                  },
                ),
              ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }
}
