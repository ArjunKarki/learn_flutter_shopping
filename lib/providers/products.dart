import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _products = [];
  String userId;
  String token;
  Products(this.userId, this.token);

  List<Product> get getProducts {
    return [..._products];
  }

  List<Product> get getFavProducts {
    return _products.where((element) => element.isFav).toList();
  }

  Product getById(id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts([myproducts = false]) async {
    String filter = myproducts ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    try {
      Uri url = Uri.parse(
          'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products.json?auth=$token&$filter');

      final res = await http.get(url);
      final resJSon = jsonDecode(res.body) as Map<String, dynamic>;
      List<Product> loadedProucts = [];
      print("ressss${res.statusCode}");

      url = Uri.parse(
          'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/userFavourits/$userId.json?auth=$token');
      final favRes = await http.get(url);
      final favResJson = jsonDecode(favRes.body);

      if (resJSon != null) {
        resJSon.forEach((productId, data) {
          loadedProucts.add(Product(
              id: productId,
              title: data["title"],
              price: data["price"],
              description: data["description"],
              isFav: favResJson[productId] ?? false,
              imageUrl: data["imageUrl"]));
        });
        _products = loadedProucts;
        notifyListeners();
      }
    } catch (e) {
      print("error=> $e");
      throw e;
    }
  }

  Future<void> addProdct(Product product) async {
    final url = Uri.parse(
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products.json?auth=$token');
    try {
      await http.post(url,
          body: jsonEncode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "creatorId": userId,
          }));

      // var newProduct = Product(
      //   title: product.title,
      //   price: product.price,
      //   description: product.description,
      //   imageUrl: product.imageUrl,
      //   id: jsonDecode(res.body)["name"],
      // );
      // _products.add(newProduct);
      // notifyListeners();
    } catch (e) {
      print("error=> $e");
      throw e;
    }
  }

  void updteProduct(String id, Product product) {
    var index = _products.indexWhere((element) => element.id == id);
    if (index >= 0) {
      try {
        final url = Uri.parse(
            'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
        final res = http.patch(url,
            body: jsonEncode({
              "title": product.title,
              "description": product.description,
              "price": product.price,
              "imageUrl": product.imageUrl,
            }));
        _products[index] = product;
      } catch (e) {
        print("errr=> $e");
        throw e;
      }
    } else {
      print("No product found");
    }
    notifyListeners();
  }

  void deletProduct(String id) async {
    final url = Uri.parse(
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products/$id.json?auth=$token');
    int productIndex = _products.indexWhere((element) => element.id == id);
    Product deleteProduct = _products[productIndex];

    try {
      _products.removeWhere((element) => element.id == id);
      notifyListeners();
      final res = await http.delete(url);
      if (res.statusCode >= 300) {
        _products.insert(productIndex, deleteProduct);
      } else {
        deleteProduct = null;
      }
    } catch (e) {
      print("err $e");
      throw e;
    }
    notifyListeners();
  }
}
