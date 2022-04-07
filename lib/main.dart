import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../splashScreen/splash_screen.dart';
import 'global/global_instance_or_variable.dart';

Future<void> main() async {
  //what is for dont know. have to know
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //though I made sPref as global why here is needed. dont know
  sPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
