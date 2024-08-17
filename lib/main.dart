import 'package:firebase_core/firebase_core.dart';
import 'package:crt/screens/homePage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

//  await Firebase.initializeApp();
  try {
    await Firebase.initializeApp();
    runApp(const MyApp());
  } catch (e) {
    // runApp(
    //   const MaterialApp(
    //   //  home: Scaffold(body: Center(child: Text('Initialization Error')))
    //   )
    // );
    print("Firebase initialization error: $e");
  }
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crime Rate Tracking (CRT)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 1, 34, 3)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const Homepage(),
    );
  }
}
