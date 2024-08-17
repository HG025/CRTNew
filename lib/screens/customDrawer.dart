import 'package:crt/screens/AboutUs.dart';
import 'package:crt/screens/changePassword.dart';
import 'package:crt/screens/login.dart';
import 'package:crt/screens/myPosts.dart';
import 'package:crt/screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Customdrawer extends StatefulWidget {
  const Customdrawer({super.key});

  @override
  State<Customdrawer> createState() => _CustomdrawerState();
}

class _CustomdrawerState extends State<Customdrawer> {
  FirebaseAuth auth = FirebaseAuth.instance;

  void logOut() async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Handle back navigation
          },
        ),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 1, 34, 3),
      ),
      body: Center(
        child: Container(
          width:
              MediaQuery.of(context).size.width, // Make drawer cover full width
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  // color: Colors.white,
                  gradient: LinearGradient(
                    colors: <Color>[
                      Color.fromARGB(255, 38, 95, 84),
                      Color.fromARGB(255, 1, 29, 24),
                    ],
                  ),
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text(
                  'Profile',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Profile())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.post_add),
                title: const Text(
                  'My Posts',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Myposts())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.vpn_key),
                title: const Text(
                  'Change Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const Changepassword())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text(
                  'About Us',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const AboutUs())));
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Log Out',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('LogOut?',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            content: const Text('Do You Really Want To LogOut?',
                                style: TextStyle(fontSize: 18)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 8, 73, 11),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              TextButton(
                                onPressed: logOut,
                                child: const Text(
                                  'LogOut',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 8, 73, 11),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ));
                },
              ),
              const Divider(
                height: 5,
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Share',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: const Text('Share CRT',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            content: const Text(
                                'This part of application will be available soon!!!',
                                style: TextStyle(fontSize: 18)),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Cancel'),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 8, 73, 11),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
