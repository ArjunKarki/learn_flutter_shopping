import 'package:flutter/material.dart';

class CartItem {
  String id;
  String title;
  double price;
  int quantity;

  CartItem({this.id, this.title, this.price, this.quantity: 1});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _carts = {};

  Map<String, CartItem> get getCart {
    return {..._carts};
  }

  int get getCartLength {
    return _carts.length;
  }

  double get getTotalAmount {
    double total = 0.0;
    _carts.forEach((key, value) {
      total += value.price * value.quantity;
    });
    return total;
  }

  void deleteCart(String id) {
    _carts.remove(id);
    notifyListeners();
  }

  void addCart({String productId, String title, double price}) {
    if (_carts.containsKey(productId)) {
      _carts.update(
        productId,
        (existingProduct) => CartItem(
          id: existingProduct.id,
          title: existingProduct.title,
          price: existingProduct.price,
          quantity: existingProduct.quantity + 1,
        ),
      );
    } else {
      _carts.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void clearCart() {
    _carts = {};
    notifyListeners();
  }
}
