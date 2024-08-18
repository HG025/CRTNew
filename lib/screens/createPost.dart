import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crt/screens/customData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_Storage;
import 'package:path/path.dart' as path;

class Createpost extends StatefulWidget {
  const Createpost({super.key});

  @override
  State<Createpost> createState() => _CreatepostState();
}

class _CreatepostState extends State<Createpost> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String dropdownValue = 'ChooseCrimeType';
  String dropdownValue1 = 'ChooseCrimeArea';

  late String imagePath;
  final TextEditingController detailsController = TextEditingController();
  CollectionReference posts = FirebaseFirestore.instance.collection('Posts');

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = image!.path;
    });
  }

  void submitpost() async {
    if (!_formKey.currentState!.validate()) {
      // Form is not valid
      return;
    }
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        Fluttertoast.showToast(
            msg: "You need to be logged in to perform this action.",
            fontSize: 15,
            toastLength: Toast.LENGTH_LONG);
        return;
      }
      if (imagePath == null) {
        Fluttertoast.showToast(
          msg: "Please select an image before submitting.",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG,
        );
        return;
      }

      String userId = user.uid;
      String imageName = path.basename(imagePath);
      firebase_Storage.Reference ref =
          firebase_Storage.FirebaseStorage.instance.ref('/$imageName');
      File file = File(imagePath);
      await ref.putFile(file);
      String downloadURL = await ref.getDownloadURL();
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection("Posts").add({
        "Choose Crime Type": dropdownValue,
        "Crime Date": dateinput.text,
        "Location": dropdownValue1,
        "Details": detailsController.text,
        "imageURl": downloadURL,
        "userId": userId,
        "timestamp": FieldValue.serverTimestamp(),
      });
      Fluttertoast.showToast(
          msg: "Post Uploaded Successfully.",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);

      _dropdownlist.currentState?.reset();
      _dropdownlist1.currentState?.reset();
      dateinput.clear();
      detailsController.clear();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Failed To Create Post.",
          fontSize: 15,
          toastLength: Toast.LENGTH_LONG);
    }
  }

  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    dateinput.text = "";
    super.initState();
  }

  GlobalKey<FormState> _dropdownlist = GlobalKey<FormState>();
  GlobalKey<FormState> _dropdownlist1 = GlobalKey<FormState>();
  DateTime? _selectedDate;

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
          title: const Text('Create Post'),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 1, 34, 3),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
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
          'lib/assets/CRT-logo.png',
          width: 100,
        ),
      ],
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: pickImage,
          style: ElevatedButton.styleFrom(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Pick Image",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          key: _dropdownlist,
          hint: const Text("Select Crime Type"),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
          ),
          onChanged: (newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          validator: (value) {
            if (value == 'ChooseCrimeType') {
              return 'Please select a crime type';
            }
            return null;
          },
          items: crimeTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: dateinput,
          readOnly: true,
          decoration: InputDecoration(
            hintText: _selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                : 'Select Date',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
            prefixIcon: const Icon(Icons.calendar_today),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2101));
            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('yyyy-MM-dd').format(pickedDate);
              setState(() {
                dateinput.text = formattedDate;
              });
            }
          },
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          key: _dropdownlist1,
          hint: const Text("Select Crime Area"),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
          ),
          onChanged: (newValue) {
            setState(() {
              dropdownValue1 = newValue!;
            });
          },
          validator: (value) {
            if (value == 'ChooseCrimeArea') {
              return 'Please select a crime area';
            }
            return null;
          },
          items: crimeAreas.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: detailsController,
          decoration: InputDecoration(
            hintText: "Enter your text",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter details';
            }
            return null;
          },
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: submitpost,
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Submit Post",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}
