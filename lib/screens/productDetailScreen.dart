import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class ProductDetail extends StatelessWidget {
  // final String title;
  // ProductDetail(this.title);

  static const routeName = "/productDetail";
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    Product product = Provider.of<Products>(context, listen: false).getById(id);
    print(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(product.title),
            SizedBox(
              height: 20,
            ),
            Text(
              product.description,
            ),
          ],
        ),
      ),
    );
  }
}
