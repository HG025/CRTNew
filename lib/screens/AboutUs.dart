import 'package:flutter/material.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({super.key});

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
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
          title: const Text('About Us'),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 1, 34, 3),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _header(context),
              _detailsField(context),
            ],
          ),
        ),
      ),
    );
  }

  _header(context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/CRT-logo.png', // Make sure the path is correct
          width: 100,
          height: 100,
        ),
      ],
    );
  }

  _detailsField(context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Version 1.0.0.1",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "Your Safety is our priority",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "Release Date: xx/xx/xxxx",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "CRT is a mobile application which "
                  "provides you the facility to post "
                  "about the crime which is "
                  "happened with you",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
