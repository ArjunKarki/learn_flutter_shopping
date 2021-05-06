import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

import 'package:shopping_app/widgets/productItems.dart';

class ProductGrid extends StatelessWidget {
  final bool showOnlyFav;

  ProductGrid(this.showOnlyFav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    List<Product> loadedProducts =
        showOnlyFav ? productData.getFavProducts : productData.getProducts;
    return GridView.builder(
      padding: const EdgeInsets.all(5),
      itemCount: loadedProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 5,
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5,
      ),
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: loadedProducts[i],
        child: ProductItem(),
      ),
    );
  }
}
