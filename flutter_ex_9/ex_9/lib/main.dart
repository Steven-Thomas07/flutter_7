import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart'; // 👈 important line

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MaterialApp(
    home: UpdateBookScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class UpdateBookScreen extends StatefulWidget {
  const UpdateBookScreen({super.key});

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _copiesController = TextEditingController();
  String? author;
  int? copies;
  String status = '';

  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  // 🔍 Search book by title
  Future<void> searchBook() async {
    final query = await books
        .where('title', isEqualTo: _titleController.text.trim())
        .get();

    if (query.docs.isNotEmpty) {
      final book = query.docs.first;
      setState(() {
        author = book['author'];
        copies = book['copies'];
        _copiesController.text = book['copies'].toString();
        status = 'Book found!';
      });
    } else {
      setState(() {
        author = null;
        copies = null;
        status = 'No book found with that title.';
      });
    }
  }

  // ✏️ Update book copies
  Future<void> updateBook() async {
    final query = await books
        .where('title', isEqualTo: _titleController.text.trim())
        .get();

    if (query.docs.isNotEmpty) {
      final docId = query.docs.first.id;
      await books.doc(docId).update({
        'copies': int.parse(_copiesController.text),
      });
      setState(() {
        copies = int.parse(_copiesController.text);
        status = 'Book copies updated successfully!';
      });
    } else {
      setState(() {
        status = 'No book found to update.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Book Copies'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Enter Book Title'),
            ),
            TextField(
              controller: _copiesController,
              decoration:
                  const InputDecoration(labelText: 'Updated Number of Copies'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: searchBook, child: const Text('Search')),
                ElevatedButton(onPressed: updateBook, child: const Text('Update')),
              ],
            ),
            const SizedBox(height: 20),
            if (author != null)
              Card(
                color: Colors.grey[200],
                child: ListTile(
                  title: Text('Title: ${_titleController.text}'),
                  subtitle: Text('Author: $author\nCopies: $copies'),
                ),
              ),
            const SizedBox(height: 10),
            Text(status, style: const TextStyle(color: Colors.blue)),
          ],
        ),
      ),
    );
  }
}
