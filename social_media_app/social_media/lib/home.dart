import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:social_media/login.dart';
import 'dart:typed_data';

import 'package:social_media/profile.dart'; // For Uint8List


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Uint8List? _imageBytes;
  final picker = ImagePicker();
  final TextEditingController captionController = TextEditingController();

  Future<void> uploadPost() async {
    if (_imageBytes == null) return;

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child("posts/$fileName");
    UploadTask uploadTask = storageRef.putData(_imageBytes!);
    await uploadTask;

    String downloadUrl = await storageRef.getDownloadURL();
    await FirebaseFirestore.instance.collection("post").add({
      "imageUrl": downloadUrl,
      "caption": captionController.text,
      "timestamp": FieldValue.serverTimestamp(),
      "userId": FirebaseAuth.instance.currentUser!.uid,
    });

    captionController.clear();
    setState(() {
      _imageBytes = null;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Post uploaded")));
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.orange],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("post")
                  .orderBy("timestamp", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No posts yet"));
                }

                return ListView(
                  children: snapshot.data!.docs.map((doc) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                            child: Image.network(doc["imageUrl"], fit: BoxFit.cover),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Text(doc["caption"], style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          if (_imageBytes != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.memory(
                _imageBytes!,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              controller: captionController,
              decoration: InputDecoration(
                labelText: "Caption",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(icon: Icon(Icons.photo), onPressed: pickImage),
              Spacer(),
              ElevatedButton(onPressed: uploadPost, child: Text("Post")),
            ],
          )
        ],
      ),
    );
  }
}
