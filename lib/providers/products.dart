import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:http/http.dart' as http;

// Product(
//   id: 'p1',
//   title: 'Red Shirt',
//   description: 'A red shirt - it is pretty red!',
//   price: 29.99,
//   imageUrl:
//       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
// ),
// Product(
//   id: 'p2',
//   title: 'Trousers',
//   description: 'A nice pair of trousers.',
//   price: 59.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
// ),
// Product(
//   id: 'p3',
//   title: 'Yellow Scarf',
//   description: 'Warm and cozy - exactly what you need for the winter.',
//   price: 19.99,
//   imageUrl:
//       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
// ),
// Product(
//   id: 'p4',
//   title: 'A Pan',
//   description: 'Prepare any meal you want.',
//   price: 49.99,
//   imageUrl:
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
// ),
//
class Products with ChangeNotifier {
  List<Product> _products = [];

  String authToken;

  // Products(this.authToken);

  List<Product> get getProducts {
    return [..._products];
  }

  List<Product> get getFavProducts {
    return _products.where((element) => element.isFav).toList();
  }

  Product getById(id) {
    return _products.firstWhere((element) => element.id == id);
  }

  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse(
          'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products.json');
      final res = await http.get(url);
      List<Product> loadedProucts = [];
      final resJSon = jsonDecode(res.body) as Map<String, dynamic>;
      if (resJSon != null) {
        resJSon.forEach((productId, data) {
          loadedProucts.add(Product(
              id: productId,
              title: data["title"],
              price: data["price"],
              description: data["description"],
              isFav: data["isFav"],
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
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products.json');
    try {
      final res = await http.post(url,
          body: jsonEncode({
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "isFav": product.isFav
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
            'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products/$id.json');
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
        'https://fluttershop-ea6ea-default-rtdb.firebaseio.com/products/$id.json');
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
