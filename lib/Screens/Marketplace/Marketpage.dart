import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:trova/class/product_class.dart';

class MarketPage extends StatelessWidget {
  ProductClass _productClass = ProductClass();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market place',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        toolbarHeight: 80,
        // leading: IconButton(
        //   //icon: Icon(Icons.store_mall_directory_sharp, color: Colors.black,size: 35,),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: Colors.black),
                    hintText: 'Search here...',
                    hintStyle: TextStyle(color: Colors.grey),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CategoryChip(label: 'Tent', icon: Icons.outdoor_grill),
                  CategoryChip(label: 'Camera', icon: Icons.camera_alt),
                  CategoryChip(label: 'Binoculars', icon: Icons.visibility),
                  CategoryChip(label: 'Shoes', icon: Icons.sports),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _productClass.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No items available.'));
                  }

                  var items = snapshot.data!;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16.0,
                      mainAxisSpacing: 16.0,
                      childAspectRatio: (1 / 1.55),
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      return ItemCard(product: item);
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

class CategoryChip extends StatelessWidget {
  final String label;
  final IconData icon;

  CategoryChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Chip(
        label: Row(
          children: [
            Icon(icon, size: 20),
            SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 14)),
          ],
        ),
        backgroundColor: Colors.grey[200],
        padding: EdgeInsets.symmetric(
            vertical: 12.0, horizontal: 20.0), // Increased height
      ),
    );
  }
}

class ItemCard extends StatelessWidget {
  final Map<String, dynamic> product;

  ItemCard({
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              topRight: Radius.circular(8),
            ),
            child: Image.network('http://192.168.0.102/uploads/${product['images'][0]}',
                height: 120, fit: BoxFit.cover),
          ),
          // Item Details
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['name'], style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4.0),
                Text('LKR ${product['price'].toString()}',
                    style: TextStyle(fontSize: 14)),
                SizedBox(height: 4.0),
                Text("Hello",
                    style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          // Rent Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('For Rent', style: TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  final String imageUrl;
  final String name;
  final double price;
  final String category;

  Item({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.category,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      imageUrl: json['imageUrl'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
    );
  }
}
