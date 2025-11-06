import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // will be created by flutterfire configure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    title: 'Library Book Management',
    home: LibraryScreen(),
  ));
}

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? bookData;
  bool isLoading = false;
  String message = '';

  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  Future<void> searchBook() async {
    setState(() {
      isLoading = true;
      message = '';
      bookData = null;
    });

    try {
      // Search for a book by title
      final snapshot = await books
          .where('title', isEqualTo: _searchController.text.trim())
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          message = 'Book not found';
        });
      } else {
        final data = snapshot.docs.first.data() as Map<String, dynamic>;
        setState(() {
          bookData = data;
        });
      }
    } catch (e) {
      setState(() {
        message = 'Error fetching data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Book Search System'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Enter Book Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: searchBook,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (isLoading)
              const CircularProgressIndicator()
            else if (message.isNotEmpty)
              Text(
                message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              )
            else if (bookData != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title: ${bookData!['title']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Author: ${bookData!['author']}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Copies Available: ${bookData!['copies']}',
                    style: TextStyle(
                      fontSize: 18,
                      color: bookData!['copies'] == 0
                          ? Colors.red
                          : Colors.black,
                    ),
                  ),
                  if (bookData!['copies'] == 0)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Not Available – All Copies Issued',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
