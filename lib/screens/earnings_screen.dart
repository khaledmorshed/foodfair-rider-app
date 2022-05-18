import 'package:flutter/material.dart';
import 'package:foodfair_rider_app/screens/rider_home_screen.dart';

import '../global/global_instance_or_variable.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({Key? key}) : super(key: key);

  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Tk " + previousRiderEarnigs,
                style: const TextStyle(
                    fontSize: 80, color: Colors.white, fontFamily: "Signatra"),
              ),
              const Text(
                "Total Earnings",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
                width: 200,
                child: Divider(
                  color: Colors.white,
                  thickness: 1.5,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (c) => const RiderHomeScreen()));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: Card(
                    color: Colors.white54,
                    child: ListTile(
                      leading: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                      title: Text(
                        "Back",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
