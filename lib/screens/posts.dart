import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:cached_network_image/cached_network_image.dart';

class Posts extends StatefulWidget {
  const Posts({super.key});

  @override
  State<Posts> createState() => _PostsState();
}

class _PostsState extends State<Posts> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference post = FirebaseFirestore.instance.collection('Posts');
  FirebaseStorage storage = FirebaseStorage.instance;

  CollectionReference Users = FirebaseFirestore.instance.collection('Users');
  String userId = (FirebaseAuth.instance.currentUser!).uid;

  Future<void> getData() async {
    QuerySnapshot querySnapshot =
        await post.orderBy('timestamp', descending: false).get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<String> _getUsername(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('Users').doc(userId).get();

    if (userDoc.exists) {
      return userDoc['username'] ?? 'Unknown';
    } else {
      return 'Unknown';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Posts')
            .orderBy("timestamp", descending: true)
            .limit(20)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("NO Posts"));
          }

          return ListView(
            children:
                snapshot.data!.docs.map((doc) => _buildPostItem(doc)).toList(),
          );
        },
      ),
    );
  }

  Widget _buildPostItem(DocumentSnapshot doc) {
    String userId = doc['userId'];
    Timestamp timestamp = doc['timestamp'] as Timestamp;

    return FutureBuilder<String>(
      future: _getUsername(userId),
      builder: (BuildContext context, AsyncSnapshot<String> usernameSnapshot) {
        if (usernameSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (usernameSnapshot.hasError) {
          return Center(child: Text('Error: ${usernameSnapshot.error}'));
        }

        if (!usernameSnapshot.hasData) {
          return const Center(child: Text('Username not found'));
        }

        String username = usernameSnapshot.data!;
        String relativeTime = timestamp != null
            ? timeago.format(timestamp.toDate(), locale: 'en_short')
            : 'Unknown time';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    leading: const Icon(Icons.account_circle, size: 50),
                    title: Text(
                      username,
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
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Text(doc["Choose Crime Type"],
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Crime Date:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Text(doc["Crime Date"],
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Crime Location:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Text(doc["Location"],
                                style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Crime Details:",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 16),
                            Text(doc["Details"],
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
                        height: MediaQuery.of(context).size.height * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(doc['imageURl']),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3)
          ],
        );
      },
    );
  }
}
