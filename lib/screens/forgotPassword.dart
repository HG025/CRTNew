import 'package:flutter/material.dart';
import 'package:crt/screens/customValidations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Forgotpassword extends StatefulWidget {
  const Forgotpassword({super.key});

  @override
  State<Forgotpassword> createState() => _ForgotpasswordState();
}

class _ForgotpasswordState extends State<Forgotpassword> {
  final UserEmailController = TextEditingController();

  void resetpassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: UserEmailController.text.trim());
      Fluttertoast.showToast(
          msg: "Password Reset Email is sent to ${UserEmailController.text}",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pop(context);
      });
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(
          msg: "$e", fontSize: 15, toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: const Text('Forgot Password'),
            foregroundColor: const Color.fromARGB(255, 255, 255, 255),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          body: Container(
            margin: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context),
              ],
            ),
          ),
        ));
  }

  _header(context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/CRT-logo.png', // Make sure the path is correct
          width: 100,
          //height: 100,
        ),
      ],
    );
  }

  _inputField(context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: UserEmailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(255, 199, 190, 190),
              filled: true,
              prefixIcon: const Icon(Icons.email)),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: resetpassword,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Reset Password",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(
          height: 190,
        ),
      ],
    ));
  }
}
