import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crt/screens/customValidations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isObscure = true;
  bool _isObscure1 = true;
  bool _isObscure2 = true;

  Future<void> changePassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        final User? user = FirebaseAuth.instance.currentUser;
        final String currentPassword = currentPasswordController.text;
        final String newPassword = newPasswordController.text;
        final String confirmPassword = confirmPasswordController.text;

        if (user == null) {
          Fluttertoast.showToast(
              msg: "No user is currently signed in!",
              fontSize: 15,
              toastLength: Toast.LENGTH_LONG);
          return;
        }

        if (newPassword != confirmPassword) {
          Fluttertoast.showToast(
              msg: "New passwords do not match",
              fontSize: 15,
              toastLength: Toast.LENGTH_LONG);
          return;
        }

        final AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );

        await user.reauthenticateWithCredential(credential);

        await user.updatePassword(newPassword);
        await user.reload();
        final updatedUser = FirebaseAuth.instance.currentUser;

        if (updatedUser != null) {
          final userDocRef = FirebaseFirestore.instance
              .collection('Users')
              .doc(updatedUser.uid);
          await userDocRef.update({
            'password': newPassword,
          });

          Fluttertoast.showToast(
              msg: "Password changed successfully",
              fontSize: 15,
              toastLength: Toast.LENGTH_LONG);
          Navigator.of(context).pop();
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Error: ${e.toString()}",
            fontSize: 15,
            toastLength: Toast.LENGTH_LONG);
      }
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
              Navigator.of(context).pop(); // Handle back navigation
            },
          ),
          title: const Text('Change Password'),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 1, 34, 3),
        ),
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _header(context),
                _inputField(context),
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
          obscureText: _isObscure,
          controller: currentPasswordController,
          decoration: InputDecoration(
            hintText: "Current Password",
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
          controller: newPasswordController,
          decoration: InputDecoration(
            hintText: "New Password",
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
          validator: validatePassword,
        ),
        const SizedBox(height: 10),
        TextFormField(
          obscureText: _isObscure2,
          controller: confirmPasswordController,
          decoration: InputDecoration(
            hintText: "Confirm New Password",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  _isObscure2 = !_isObscure2;
                });
              },
              icon: Icon(_isObscure2 ? Icons.visibility : Icons.visibility_off),
              color: const Color.fromARGB(255, 8, 73, 11),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            }
            if (value != newPasswordController.text) {
              return 'Passwords do not match';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: changePassword,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Change Password",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
