import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Restaurant Menu",
      theme: ThemeData(
        primarySwatch: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      home: const RestaurantMenuScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RestaurantMenuScreen extends StatelessWidget {
  const RestaurantMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Menu"),
        actions: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              margin: const EdgeInsets.only(bottom: 15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search dishes...",
                  border: InputBorder.none,
                  icon: Icon(Icons.search),
                ),
              ),
            ),
            // Dish Item
            Expanded(
              child: ListView(
                children: [
                  dishCard(
                    "Spaghetti Bolognese",
                    "Classic Italian dish with a rich meat sauce",
                    "https://imgs.search.brave.com/5quTar_DXgVQ48WSFQisLgmpc3qjMb59FyFwzeOqiqU/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi80LzRkL1Rh/Z2xpYXRlbGxlX2Fs/X3JhZyVDMyVCOV8l/MjhpbWFnZV9tb2Rp/ZmllZCUyOS5qcGcv/NTEycHgtVGFnbGlh/dGVsbGVfYWxfcmFn/JUMzJUI5XyUyOGlt/YWdlX21vZGlmaWVk/JTI5LmpwZw",
                    "\$15.99",
                  ),
                  dishCard(
                    "Margherita Pizza",
                    "A timeless classic with fresh basil and mozzarella",
                    "https://imgs.search.brave.com/uT9FtL6iO3n6yG9mnDbRUDI_SVa7mcrW9jQ4MEAbjtI/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi9jL2M4L1Bp/enphX01hcmdoZXJp/dGFfc3R1X3NwaXZh/Y2suanBnLzUxMnB4/LVBpenphX01hcmdo/ZXJpdGFfc3R1X3Nw/aXZhY2suanBn",
                    "\$12.50",
                  ),
                  dishCard(
                    "Caesar Salad",
                    "Crisp romaine lettuce with croutons and creamy dressing",
                    "https://imgs.search.brave.com/E1odJAG03plyAOZ0V6hoa4cJ3awdTLsdx08X77NLRp0/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly91cGxv/YWQud2lraW1lZGlh/Lm9yZy93aWtpcGVk/aWEvY29tbW9ucy90/aHVtYi8yLzIzL0Nh/ZXNhcl9zYWxhZF8l/MjgyJTI5LmpwZy81/MTJweC1DYWVzYXJf/c2FsYWRfJTI4MiUy/OS5qcGc",
                    "\$10.25",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget for each dish
  Widget dishCard(String title, String desc, String imageUrl, String price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text("Add to Cart"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}