import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'RestaurantMenu',
            style: TextStyle(fontSize: 20, letterSpacing: 7),
          ),
          backgroundColor: Colors.blueGrey,
        ),
        body: ListView(
          children: const [
            MyListItem(playlistName: 'Pasta', imageUrl: 'assets/images/img1.jpg'),
            MyListItem(playlistName: 'Chicken Biriyani', imageUrl: 'assets/images/img2.jpg'),
            MyListItem(playlistName: 'Noodles', imageUrl: 'assets/images/img3.jpg'),
            MyListItem(playlistName: 'Cookies', imageUrl: 'assets/images/img4.jpg'),
            MyListItem(playlistName: 'Pizza', imageUrl: 'assets/images/img5.jpg'),
            MyListItem(playlistName: 'Salad', imageUrl: 'assets/images/img6.jpg'),
            MyListItem(playlistName: 'Soup', imageUrl: 'assets/images/img7.jpg'),
          ],
        ),
      ),
    );
  }
}

class MyListItem extends StatelessWidget {
  final String playlistName, imageUrl;
  const MyListItem({super.key, required this.playlistName, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      elevation: 1,
      color: const Color.fromARGB(255, 211, 206, 210),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.grey[200],
            width: 200,
            height: 200,
            child: Image.asset(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                playlistName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.play_circle_fill, size: 40, color: Colors.blueGrey),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
