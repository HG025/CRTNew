import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crt/screens/customNavigations.dart';
import 'package:crt/screens/customValidations.dart';
import 'package:crt/screens/forgotPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'signup.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController UserEmailController = TextEditingController();
  final TextEditingController UserPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool flag = true;

  void navBar1() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final String email = UserEmailController.text;
    final String password = UserPasswordController.text;

    if (_formKey.currentState!.validate()) {
    } else {
      Fluttertoast.showToast(
          msg: "Error...!!", fontSize: 15, toastLength: Toast.LENGTH_LONG);
    }
    try {
      final UserCredential user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      final DocumentSnapshot snapshot =
          await db.collection("Users").doc(user.user?.uid).get();
      Fluttertoast.showToast(
          msg: "Welcome to CRT", fontSize: 15, toastLength: Toast.LENGTH_LONG);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Customnavigations()),
      );
    } catch (e) {
      Fluttertoast.showToast(
          msg: "User Login Failed...",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
        snackBar: const SnackBar(
          content: Text('Tap again to exit !'),
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Container(
              margin: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _header(context),
                    _inputField(context),
                    _forgotPassword(context),
                    _signup(context),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  _header(context) {
    return Column(
      children: [
        Image.asset(
          'lib/assets/CRT-logo.png',
          width: 100,
          height: 100,
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: UserEmailController,
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(255, 199, 190, 190),
              filled: true,
              prefixIcon: const Icon(Icons.email)),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: UserPasswordController,
          obscureText: _isObscure,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              },
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              color: const Color.fromARGB(255, 8, 73, 11),
            ),
          ),
          validator: validatePassword,
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              navBar1();
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Forgotpassword()),
        );
      },
      child: const Text(
        "Forgot password?",
        style: TextStyle(
          color: Color.fromARGB(255, 1, 34, 3),
        ),
      ),
    );
  }

  _signup(context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account? "),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Signup()),
                );
              },
              child: const Text(
                "Sign Up",
                style: TextStyle(
                  color: Color.fromARGB(255, 1, 34, 3),
                ),
              ),
            ),
          ],
        ));
  }
}
