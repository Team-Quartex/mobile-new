import 'package:flutter/material.dart';
import 'package:trova/api_service.dart';
import 'package:trova/class/product_class.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  late ProductClass productClass;
  ApiService? _apiService;
  int? userId;
  String? profilePic;

  @override
  void initState() {
    super.initState();
    productClass = ProductClass();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        toolbarHeight: 80,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: productClass.fetchOrderHistory(userId!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found.'));
          } else {
            final orders = snapshot.data!;
            return ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: orders.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade200,
                    radius: 30,
                    backgroundImage: order['productImage'] != null
                        ? NetworkImage(
                            "http://192.168.0.102/uploads/${order['productImage']}")
                        : const AssetImage('assets/default_image.png')
                            as ImageProvider,
                  ),
                  title: Text(
                    order['productName'] ?? 'Item Name',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "LKR ${order['price']?.toStringAsFixed(2) ?? '00.00'}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text("Qty: ${order['quantity'] ?? 1}"),
                    ],
                  ),
                  trailing: Text(
                    order['orderDate'] ?? 'Date/Time',
                    style: const TextStyle(
                      color: Colors.teal,
                      fontSize: 14,
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
