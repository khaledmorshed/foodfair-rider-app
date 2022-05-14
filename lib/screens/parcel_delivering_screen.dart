import 'package:flutter/material.dart';

class ParcelDeliveringScreen extends StatefulWidget {
  final String? purchaserId;
  final String? purchaserAddress;
  double? purchaserLatitude;
  double? purchaserLongitude;
  final String? sellerId;
  final String? orderId;
  
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
  }
}