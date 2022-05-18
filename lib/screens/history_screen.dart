import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair_rider_app/global/global_instance_or_variable.dart';
import '../exceptions/progress_bar.dart';
import '../global/add_item_to_cart.dart';
import '../widgets/my_order_wiget.dart';
import '../widgets/simple_appbar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: SimpleAppbar(title: "History"),
        body: StreamBuilder<QuerySnapshot>(
          //here we get the order list of order collection which are normal
          stream: FirebaseFirestore.instance
              .collection("orders")
              //not all rider just specific rider
              .where("riderUID", isEqualTo: sPref!.getString("uid"))
              .where("status", isEqualTo: "ended")
              .snapshots(),
          builder: (c, snapshot) {
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<QuerySnapshot>(
                        //here we get the productIDs list inside of order collection for a specific user.
                        future: FirebaseFirestore.instance
                            .collection("items")
                            .where("itemID",
                                whereIn: separateItemIDFromOrdersCollection(
                                    (snapshot.data!.docs[index].data()!
                                        as Map<String, dynamic>)["productIDs"]))
                            .orderBy("publishedDate", descending: true)
                            . /*instead of snapshot() we use here get(), the reason
                             for using FutureBuilder*/  
                            get(),
                        builder: (c, snap) {
                          return snap.hasData
                              ? MyOrderWidget(
                                  //snap.data!.docs.length = how many items(productIDs) is oreder by a specific user
                                  itemCount: snap.data!.docs.length,
                                  //snap.data!.docs = all productID list
                                  data: snap.data!.docs,
                                  //passing order id one by one. we know inside of a specific order
                                  //id we will get many productIDs
                                  orderID: snapshot.data!.docs[index].id,
                                  deliveryStatus: snapshot.data!.docs[index]["status"],
                                  separateItemsQuantityList:
                                      separateItemQuantityFromOrdersCollection(
                                          (snapshot.data!.docs[index].data()!
                                                  as Map<String, dynamic>)[
                                              "productIDs"]),
                                )
                              : Center(
                                  child: circularProgress(),
                                );
                        },
                      );
                    })
                : Center(
                    child: circularProgress(),
                  );
          },
        ),
      ),
    );
  }
}
