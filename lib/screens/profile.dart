import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

final TextEditingController userNameController = TextEditingController();
final TextEditingController userEmailController = TextEditingController();
final TextEditingController userPasswordController = TextEditingController();
late final String id;

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  String userId = (FirebaseAuth.instance.currentUser!).uid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(); // Handle back navigation
            },
          ),
          title: const Text('Profile'),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 1, 34, 3),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _inputField(context, userId),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        Image.asset(
          'lib/assets/CRT-logo.png', // Make sure the path is correct
          width: 100,
          height: 100,
        ),
      ],
    ));
  }

  Widget _inputField(BuildContext context, String userId) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance.collection('Users').doc(userId).get(),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        var data = snapshot.data?.data();
        var username = data?['username'] ?? '';
        var email = data?['email'] ?? '';
        var password = data?['password'] ?? '';

        // var data = snapshot.data?.data();
        // if (data == null) {
        //   return const Center(child: Text('No data available'));
        // }

        // var username = data['username'] ?? '';
        // var email = data['email'] ?? '';
        // var password = data['password'] ?? '';

        return SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              enabled: false,
              initialValue: username,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "UserName",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color.fromARGB(255, 199, 190, 190),
                filled: true,
                prefixIcon: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              enabled: false,
              initialValue: email,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color.fromARGB(255, 199, 190, 190),
                filled: true,
                prefixIcon: const Icon(Icons.email, color: Colors.black),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              enabled: false,
              initialValue: password,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color.fromARGB(255, 199, 190, 190),
                filled: true,
                prefixIcon: const Icon(Icons.lock, color: Colors.black),
              ),
            ),
            const SizedBox(height: 150),
          ],
        ));
      },
    );
  }
}
