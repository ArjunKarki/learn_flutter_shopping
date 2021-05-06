import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFav;

  Product({
    this.id,
    this.title,
    this.description,
    this.price,
    this.imageUrl,
    this.isFav = false,
  });

  void toggleFav() async {
    bool _isFav = isFav;
    isFav = !isFav;
    notifyListeners();
    final url = Uri.parse(
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products/$id.json');

    try {
      final res = await http.patch(url,
          body: jsonEncode({
            "isFav": !_isFav,
          }));
      if (res.statusCode >= 300) {
        isFav = _isFav;
        notifyListeners();
      }
    } catch (e) {
      print("error=> $e");
      throw e;
    }
  }
}
