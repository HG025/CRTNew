import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crt/screens/customData.dart';
import 'package:crt/screens/searchByCrimeDate.dart';
import 'package:crt/screens/searchByCrimeLocation.dart';
import 'package:crt/screens/searchByCrimeType.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String? _selectedDropdownValue;
  String? _selectedDropdownValue1;
  String? _selectedDropdownValue2;
  String selectedValue = "Search By Crime Type";

  DateTime? _selectedDate;

  String? _selectedCrimeType;
  String? _selectedCrimeType1;
  String? _selectedCrimeArea;

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
          title: const Text('Search'),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
          backgroundColor: const Color.fromARGB(255, 1, 34, 3),
        ),
        body: Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const SizedBox(height: 50),
              _inputField(context),
              if (_selectedDropdownValue == 'Search By Crime Type')
                _inputadditionalFieldforCrimeType(),
              if (_selectedDropdownValue == 'Search By Crime Date')
                _inputadditionalFieldforCrimeDate(),
              if (_selectedDropdownValue == 'Search By Crime Location')
                _inputadditionalFieldforCrimeLocation(),
              _inputButton(context),
              const SizedBox(height: 50)
            ],
          ),
        ),
      ),
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _selectedDropdownValue,
          hint: const Text("Select Search Option"),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedDropdownValue = newValue;
              _selectedCrimeType = null;
              _selectedCrimeArea = null;
              _selectedDate = null;
            });
          },
          items: <String>[
            'Search By Crime Type',
            'Search By Crime Date',
            'Search By Crime Location',
          ].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  _inputadditionalFieldforCrimeType() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDropdownValue1,
          hint: const Text("ChooseCrimeType"),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedDropdownValue1 = newValue;
            });
          },
          items: crimeTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  _inputadditionalFieldforCrimeDate() {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );

            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
            }
          },
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
        )
      ],
    );
  }

  _inputadditionalFieldforCrimeLocation() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDropdownValue2,
          hint: const Text("ChooseCrimeArea"),
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromARGB(255, 199, 190, 190),
            filled: true,
          ),
          onChanged: (newValue) {
            setState(() {
              _selectedDropdownValue2 = newValue;
            });
          },
          items: crimeAreas.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }

  _inputButton(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () async {
            if (_selectedDropdownValue == 'Search By Crime Type' &&
                _selectedDropdownValue1 != null) {
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('Posts')
                  .where('Choose Crime Type',
                      isEqualTo: _selectedDropdownValue1)
                  .get();

              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map<String, dynamic>> documentsWithUsernames = [];

              for (var doc in documents) {
                var data = doc.data()
                    as Map<String, dynamic>?; // Use Map<String, dynamic>?
                if (data != null) {
                  String userId = data['userId'];
                  Timestamp timestamp = data['timestamp'];

                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .get();

                  var userData = userDoc.data() as Map<String, dynamic>?;
                  String username = userData?['username'] ?? 'Unknown User';

                  documentsWithUsernames.add({
                    ...data,
                    'username': username,
                    'timestamp': timestamp,
                  });
                } else {
                  print('Document data is null for document ID: ${doc.id}');
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Searchbycrimetype(documents: documentsWithUsernames),
                ),
              );
            } else if (_selectedDropdownValue == 'Search By Crime Date' &&
                _selectedDate != null) {
              try {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(_selectedDate!);
                QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                    .collection('Posts')
                    .where('Crime Date', isEqualTo: formattedDate)
                    .get();

                print('Selected Date: $_selectedDate');
                print('formattedDate Date: $formattedDate');
                print(
                    'Firestore Query Result: ${querySnapshot.docs.length} documents found.');
                List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                List<Map<String, dynamic>> documentsWithUsernames = [];

                for (var doc in documents) {
                  var data = doc.data() as Map<String, dynamic>?;
                  if (data != null) {
                    String userId = data['userId'];
                    Timestamp timestamp = data['timestamp'];

                    DocumentSnapshot userDoc = await FirebaseFirestore.instance
                        .collection('Users')
                        .doc(userId)
                        .get();

                    var userData = userDoc.data() as Map<String, dynamic>?;
                    String username = userData?['username'] ?? 'Unknown User';

                    documentsWithUsernames.add({
                      ...data,
                      'username': username,
                      'timestamp': timestamp,
                    });
                  } else {
                    print('Document data is null for document ID: ${doc.id}');
                  }
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Searchbycrimedate(documents: documentsWithUsernames),
                  ),
                );
              } catch (e) {
                print("hello");
              }
            } else if (_selectedDropdownValue == 'Search By Crime Location' &&
                _selectedDropdownValue2 != null) {
              QuerySnapshot querySnapshot = await FirebaseFirestore.instance
                  .collection('Posts')
                  .where('Location', isEqualTo: _selectedDropdownValue2)
                  .get();

              List<QueryDocumentSnapshot> documents = querySnapshot.docs;
              List<Map<String, dynamic>> documentsWithUsernames = [];

              for (var doc in documents) {
                var data = doc.data() as Map<String, dynamic>?;
                if (data != null) {
                  String userId = data['userId'];
                  Timestamp timestamp = data['timestamp'];

                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userId)
                      .get();

                  var userData = userDoc.data() as Map<String, dynamic>?;
                  String username = userData?['username'] ?? 'Unknown User';

                  documentsWithUsernames.add({
                    ...data,
                    'username': username,
                    'timestamp': timestamp,
                  });
                } else {
                  print('Document data is null for document ID: ${doc.id}');
                }
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Searchbycrimelocation(documents: documentsWithUsernames),
                ),
              );
            } else {
              print("else Statement");
            }
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromARGB(255, 1, 34, 3),
          ),
          child: const Text(
            "Search",
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
