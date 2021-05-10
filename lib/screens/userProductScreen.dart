import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/productEditScreen.dart';
import 'package:shopping_app/widgets/userProdctItem.dart';

class UserProductScreen extends StatelessWidget {
  static String routeName = "/myProduct";

  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My products"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, ProdctEditScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProduct(context),
                    child: Consumer<Products>(
                      builder: (_, products, __) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: products.getProducts.length,
                            itemBuilder: (context, i) => UserProductItem(
                              id: products.getProducts[i].id,
                              title: products.getProducts[i].title,
                              imgUrl: products.getProducts[i].imageUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
