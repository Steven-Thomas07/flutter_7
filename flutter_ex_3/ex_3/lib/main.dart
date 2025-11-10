import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class Music {
  String name;
  String creator;
  Music({required this.name, required this.creator});
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final List<Music> playlist = [
    Music(name: "Chicken Biriyani", creator: "₹ 300"),
    Music(name: "Pasta", creator: "₹ 250"),
    Music(name: "Pizza", creator: "₹ 450"),
    Music(name: "Salad", creator: "₹ 150"),
    Music(name: "Noodles", creator: "₹ 200"),
    Music(name: "Soup", creator: "₹ 100"),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant Menu",
      home: Scaffold(
        appBar: AppBar(
          title: Text('FoodyGuru'),
          backgroundColor: Colors.blue,
        ),
        body: ListView.builder(
          itemCount: playlist.length,
          itemBuilder: (context, index) {
            final Music = playlist[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(child: Text(Music.name[0])),
                  title: Text(Music.name),
                  subtitle: Text(Music.creator),
                  trailing: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Your Delicacies'),
                          content: Text(
                            "\"${Music.name}\" has been added to your Menu",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Ok'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Add'),
                  ),
                  onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${Music.name} is added"),
                          duration: Duration(seconds: 3),
                        )
                      );
                    },

                ),
                Divider(color: Colors.black,)
              ],
            );
          },
        ),
        
      ),
    );
  }
}