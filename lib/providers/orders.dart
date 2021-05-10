import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItems {
  String id;
  double amount;
  DateTime time;
  List<CartItem> products;

  OrderItems({this.id, this.amount, this.time, this.products});
}

class Orders with ChangeNotifier {
  List<OrderItems> _orders = [];
  String userId;
  String token;
  Orders(this.userId, this.token);

  List<OrderItems> get getOrders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

    final res = await http.get(url);
    var resJson = jsonDecode(res.body) as Map<String, dynamic>;
    List<OrderItems> loadedOrders = [];
    if (resJson != null) {
      resJson.forEach((orderId, value) {
        loadedOrders.add(
          OrderItems(
            id: orderId,
            amount: value["amount"],
            time: DateTime.parse(value["time"]),
            products: (value["products"] as List<dynamic>)
                .map((ci) => CartItem(
                      id: ci["id"],
                      price: ci["price"],
                      quantity: ci["quantity"],
                      title: ci["title"],
                    ))
                .toList(),
          ),
        );
      });
    }
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(double amount, List<CartItem> products) async {
    final url = Uri.parse(
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token');

    await http.post(url,
        body: jsonEncode({
          "amount": amount,
          "time": DateTime.now().toIso8601String(),
          "products": products
              .map((p) => {
                    "id": p.id,
                    "title": p.title,
                    "price": p.price,
                    "quantity": p.quantity,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItems(
        id: DateTime.now().toString(),
        amount: amount,
        time: DateTime.now(),
        products: products,
      ),
    );
    notifyListeners();
  }
}
