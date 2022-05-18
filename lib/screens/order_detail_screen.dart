import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../exceptions/progress_bar.dart';
import '../global/global_instance_or_variable.dart';
import '../models/address.dart';
import '../widgets/for_picking_widget.dart';
import '../widgets/order_status_babber.dart';

class OrderDetailScreen extends StatefulWidget {
  final String? orderID;
  String? deliveryStatus;
  OrderDetailScreen({
    Key? key,
    this.orderID,
    this.deliveryStatus,
  }) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  String orderStatus = "";
  String orderByUser = "";
  String sellerID = "";
  getOrderInformation() {
    FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderID)
        .get()
        .then((DocumentSnapshot) {
      orderStatus = DocumentSnapshot.data()!["status"].toString();
      orderByUser = DocumentSnapshot.data()!["orderBy"].toString();
      sellerID = DocumentSnapshot.data()!["sellerUID"].toString();
    });
  }

  @override
  void initState() {
    getOrderInformation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("orders")
              .doc(widget.orderID)
              .get(),
          builder: (c, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              //all firebase order stored inside of dataMap
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap["status"].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        OrderStatusBanner(
                          status: dataMap!["isSuccess"],
                          orderStatus: orderStatus,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Tk ${dataMap["totalAmount"]}",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order ID = ${widget.orderID}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Text(
                          "Order at: " +
                              DateFormat("dd MMMM, yyyy - hh:mm aa").format(
                                  DateTime.parse(dataMap["orderTime"])
                                  /*DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(dataMap["orderTime"]))*/
                                  ),
                        ),
                        const Divider(
                          thickness: 4,
                        ),
                        orderStatus == "ended"
                            ? Image.asset("assets/images/success.jpg")
                            : Image.asset("assets/images/confirm_pick.png"),
                        const Divider(
                          thickness: 4,
                        ),
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("users")
                              .doc(orderByUser)
                              .collection("userAddress")
                              .doc(dataMap[
                                  "addressID"]) /*specific address with specific order*/ .get(),
                          builder: (c, snapshot) {
                            return snapshot.hasData
                                ? ForPickingWidget(
                                    addressModel: Address.fromJson(
                                        snapshot.data!.data()!
                                            as Map<String, dynamic>),
                                    orderStatus: orderStatus,
                                    orderID: widget.orderID,
                                    sellerUID: sellerID,
                                    orderByUser: orderByUser,
                                    deliveryStatus: widget.deliveryStatus,
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
