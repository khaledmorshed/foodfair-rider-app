import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'container_decoration.dart';

class OrderStatusBanner extends StatelessWidget {
  final bool? status;
  final String? orderStatus;
  const OrderStatusBanner({
    Key? key,
    this.status,
    this.orderStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? message;
    IconData? iconData;

    status! ? iconData = Icons.done : iconData = Icons.cancel;
    status! ? message = "Successfully" : message = "Unsuccessfully";

    return Container(
      decoration: ContainerDecoration().decoaration(),
      margin: EdgeInsets.only(top: 30),
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserHomeScreen()));
            },
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          const SizedBox(
            width: 50,
          ),*/
          Text(
            orderStatus == "ended"
                ? "Parcel delivered $message"
                : "Order placed $message",
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          const SizedBox(
            width: 20,
          ),
          CircleAvatar(
            radius: 8,
            backgroundColor: Colors.black26,
            child: Center(
              child: Icon(
                iconData,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
