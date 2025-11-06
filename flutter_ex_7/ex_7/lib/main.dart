import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _copiesController = TextEditingController();
  String status = '';

  final CollectionReference books =
      FirebaseFirestore.instance.collection('books');

  Future<void> addBook() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      await books.add({
        'title': _titleController.text,
        'author': _authorController.text,
        'copies': int.parse(_copiesController.text),
      });

      _titleController.clear();
      _authorController.clear();
      _copiesController.clear();

      setState(() {
        status = "Data saved successfully.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Book Management System'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration:
                            const InputDecoration(labelText: 'Book Title'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter book title'
                            : null,
                      ),
                      TextFormField(
                        controller: _authorController,
                        decoration:
                            const InputDecoration(labelText: 'Author'),
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter author name'
                            : null,
                      ),
                      TextFormField(
                        controller: _copiesController,
                        decoration: const InputDecoration(
                            labelText: 'Copies Available'),
                        keyboardType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Please enter number of copies'
                            : null,
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: addBook,
                        child: const Text('Add Book'),
                      ),
                      const SizedBox(height: 10),
                      if (status.isNotEmpty)
                        Text(
                          status,
                          style: const TextStyle(color: Colors.green),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              flex: 3,
              child: StreamBuilder<QuerySnapshot>(
                stream: books.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final records = snapshot.data!.docs;
                  if (records.isEmpty) {
                    return const Center(child: Text('No books available.'));
                  }
                  return ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final book = records[index];
                      return ListTile(
                        title: Text(book['title']),
                        subtitle: Text(
                            'Author: ${book['author']} | Copies: ${book['copies']}'),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
