import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Searchbycrimedate extends StatefulWidget {
  final List<Map<String, dynamic>> documents;
  const Searchbycrimedate({Key? key, required this.documents})
      : super(key: key);

  @override
  State<Searchbycrimedate> createState() => _SearchbycrimedateState();
}

class _SearchbycrimedateState extends State<Searchbycrimedate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Handle back navigation
          },
        ),
        title: const Text('Search By Crime Date'),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        backgroundColor: const Color.fromARGB(255, 1, 34, 3),
      ),
      body: widget.documents.isEmpty
          ? const Center(child: Text("NO Posts Available"))
          : ListView.builder(
              itemCount: widget.documents.length,
              itemBuilder: (context, index) {
                final doc = widget.documents[index];
                final timestamp = doc['timestamp'] as Timestamp?;
                final DateTime? dateTime = timestamp?.toDate();

                final String relativeTime = dateTime != null
                    ? timeago.format(dateTime)
                    : 'Unknown Time';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.account_circle, size: 50),
                            title: Text(
                              doc['username'] ?? 'Unknown User',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 0.5,
                                height: 1.2,
                              ),
                            ),
                            subtitle: Text(
                              relativeTime,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Container(
                            margin: const EdgeInsets.all(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    const Text("Crime Type:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 16),
                                    Text(doc["Choose Crime Type"] ?? 'N/A',
                                        style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Crime Date:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 16),
                                    Text(doc["Crime Date"] ?? 'N/A',
                                        style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Crime Location:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 16),
                                    Text(doc["Location"] ?? 'N/A',
                                        style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Text("Crime Details:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(width: 16),
                                    Text(doc["Details"] ?? 'N/A',
                                        style: const TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Column(
                            children: [
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(doc['imageURl'] ??
                                        'https://via.placeholder.com/150'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 3),
                  ],
                );
              },
            ),
    );
  }
}
