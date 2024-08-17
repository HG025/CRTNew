import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crt/screens/customValidations.dart';
import 'package:crt/screens/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:email_otp/email_otp.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isObscure = true;
  bool _isObscure1 = true;
  late EmailOTP emailOTP;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController UserNameController = TextEditingController();
  final TextEditingController UserEmailController = TextEditingController();
  final TextEditingController UserOTPController = TextEditingController();
  final TextEditingController UserPasswordController = TextEditingController();
  final TextEditingController UserConfirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    EmailOTP.config(
      appName: 'Crime Rate Tracking',
      otpType: OTPType.numeric,
      expiry: 100000,
      emailTheme: EmailTheme.v4,
      appEmail: 'crtHelp@CrimeRateTracking.com',
      otpLength: 4,
    );
  }

  @override
  void dispose() {
    UserNameController.dispose();
    UserEmailController.dispose();
    UserOTPController.dispose();
    UserPasswordController.dispose();
    UserConfirmPasswordController.dispose();
    super.dispose();
  }

  void sendOTP() async {
    String email = UserEmailController.text;

    bool result = await EmailOTP.sendOTP(
      email: email,
    );

    if (result) {
      Fluttertoast.showToast(
          msg: "OTP sent to $email",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: "Failed to send OTP",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  void verifyOTP() async {
    var isValid = EmailOTP.verifyOTP(
      //  email: UserEmailController.text,
      otp: UserOTPController.text,
    );

    if (isValid) {
      Fluttertoast.showToast(
          msg: "OTP Verified", fontSize: 15, toastLength: Toast.LENGTH_LONG);
    } else {
      Fluttertoast.showToast(
          msg: "Invalid OTP", fontSize: 15, toastLength: Toast.LENGTH_LONG);
    }
  }

  void signed() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    final String username = UserNameController.text;
    final String email = UserEmailController.text;
    final String password = UserPasswordController.text;
    final String ConfPass = UserConfirmPasswordController.text;

    if (_formKey.currentState!.validate()) {
      try {
        final UserCredential user = await auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (user.user != null) {
          await db.collection("Users").doc(user.user?.uid).set({
            "username": username,
            "email": email,
            "password": password,
          });

          UserNameController.clear();
          UserEmailController.clear();
          UserPasswordController.clear();
          UserOTPController.clear();
          UserConfirmPasswordController.clear();

          Fluttertoast.showToast(
              msg: "User Registered Successfully",
              fontSize: 15,
              toastLength: Toast.LENGTH_LONG);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "User Registration Failed. \n Already Registed!",
            fontSize: 15,
            toastLength: Toast.LENGTH_LONG);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Form Validation Failed",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context),
                _login(context),
              ],
            ),
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
          //  height: 100,
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: UserNameController,
          decoration: InputDecoration(
              hintText: "Username",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none),
              fillColor: const Color.fromARGB(255, 199, 190, 190),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
          validator: validateUsername,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: UserEmailController,
          decoration: InputDecoration(
            hintText: 'abc@gmail.com',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
            prefixIcon: const Icon(Icons.email),
            suffixIcon: TextButton(
              onPressed: sendOTP,
              child: const Text(
                "Send OTP",
                style: TextStyle(
                  color: Color.fromARGB(255, 1, 34, 3),
                ),
              ),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
          validator: validateEmail,
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: UserOTPController,
          decoration: InputDecoration(
            hintText: "OTP ",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
            prefixIcon: const Icon(Icons.password),
            suffixIcon: TextButton(
              onPressed: verifyOTP,
              child: const Text(
                "Verify OTP",
                style: TextStyle(
                  color: Color.fromARGB(255, 1, 34, 3),
                ),
              ),
            ),
          ),
          validator: validateOTP,
        ),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: _isObscure,
          controller: UserPasswordController,
          decoration: InputDecoration(
            hintText: "Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
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
        TextFormField(
          obscureText: _isObscure1,
          controller: UserConfirmPasswordController,
          decoration: InputDecoration(
            hintText: "Confirm Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure1 = !_isObscure1;
                });
              },
              icon: Icon(_isObscure1 ? Icons.visibility : Icons.visibility_off),
              color: const Color.fromARGB(255, 8, 73, 11),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value != UserPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: signed,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Register",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }

  _login(context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account? "),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Login()),
                );
              },
              child: const Text(
                "Login",
                style: TextStyle(
                  color: Color.fromARGB(255, 1, 34, 3),
                ),
              ),
            ),
          ],
        ));
  }
}

extension on EmailOTP {
  void initialize(
      {required String appName,
      required String appEmail,
      required int otpLength,
      required OTPType otpType}) {}
}
