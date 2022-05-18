import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/items.dart';
import '../screens/order_detail_screen.dart';

class MyOrderWidget extends StatelessWidget {
  int? itemCount;
  List<DocumentSnapshot>? data;
  String? orderID;
  List<String>? separateItemsQuantityList;
  //extra added
  String? deliveryStatus;

  MyOrderWidget({
    Key? key,
    this.itemCount,
    this.data,
    this.orderID,
    this.separateItemsQuantityList,
    this.deliveryStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(
        "deliveryStatus = $deliveryStatus + DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDdd");
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OrderDetailScreen(
                    orderID: orderID, deliveryStatus: deliveryStatus)));
      },
      child: Container(
        //color: Colors.white10,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.grey[200],
            border: Border.all(color: Colors.black12, width: 4),
            borderRadius: BorderRadius.circular(5)),
        height: itemCount! * 125,
        child: ListView.builder(
            itemCount: itemCount,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              Items itemModel =
                  Items.fromJson(data![index].data()! as Map<String, dynamic>);
              return PlacedOrderDesignWidtet(
                  itemModel, context, separateItemsQuantityList![index]);
            }),
      ),
    );
  }
}

Widget PlacedOrderDesignWidtet(
    Items itemModel, BuildContext context, separateItemsQuantityList) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 120,
    child: Row(
      children: [
        CachedNetworkImage(
          imageUrl: itemModel.itemImageUrl!,
          width: 120,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Text(
                      itemModel.itemTitle!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      "Tk ${itemModel.price}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "x $separateItemsQuantityList",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
