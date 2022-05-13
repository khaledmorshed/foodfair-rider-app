import 'package:flutter/material.dart';
import 'auth_screen.dart';
import '../global/global_instance_or_variable.dart';
import '../presentation/color_manager.dart';
import '../widgets/container_decoration.dart';
import 'new_order_screen.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
  Card makeDashboardItem(String title, IconData iconData, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Container(
        decoration: index == 0 || index == 3 || index == 4
            ? BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  ColorManager.purple2,
                  ColorManager.cyan2,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ))
            : BoxDecoration(
                gradient: LinearGradient(
                colors: [
                  //Colors.amber,
                  ColorManager.orange3,
                  ColorManager.cyan2,
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )),
        child: InkWell(
          onTap: () {
            if (index == 0) {
              //New Available Orders
               Navigator.push(context, MaterialPageRoute(builder: (c)=> NewOrderSceen()));
            }
            if (index == 1) {
              //Parcels in Progress

            }
            if (index == 2) {
              //Not Yet Delivered

            }
            if (index == 3) {
              //History

            }
            if (index == 4) {
              //Total Earnings

            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            verticalDirection: VerticalDirection.down,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: Icon(
                  iconData,
                  size: 40,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${sPref!.getString("name")}"),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const ContainerDecoration().decoaration(),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppBar(
              title: Column(
                children: [
                  //SizedBox(height: 50,),
                  Text("${sPref!.getString("name")}"),
                  Text("${sPref!.getString("email")}"),
                ],
              ),
              automaticallyImplyLeading: false,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                firebaseAuth.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AuthScreen()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 1),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(2),
          children: [
            makeDashboardItem("New Available Orders", Icons.assignment, 0),
            makeDashboardItem("Parcels in Progress", Icons.airport_shuttle, 1),
            makeDashboardItem("Not Yet Delivered", Icons.location_history, 2),
            makeDashboardItem("History", Icons.done_all, 3),
            makeDashboardItem("Total Earnings", Icons.monetization_on, 4),
          ],
        ),
      ),
    );
  }
}
