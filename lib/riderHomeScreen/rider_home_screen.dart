import 'package:flutter/material.dart';
import '../authentication/auth_screen.dart';
import '../global/global_instance_or_variable.dart';
import '../widgets/container_decoration.dart';

class RiderHomeScreen extends StatefulWidget {
  const RiderHomeScreen({Key? key}) : super(key: key);

  @override
  State<RiderHomeScreen> createState() => _RiderHomeScreenState();
}

class _RiderHomeScreenState extends State<RiderHomeScreen> {
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
    );
  }
}
