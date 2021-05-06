import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/cartScreen.dart';
import 'package:shopping_app/widgets/appDrawer.dart';
import 'package:shopping_app/widgets/badge.dart';

import 'package:shopping_app/widgets/productGrid.dart';

class ProductOverview extends StatefulWidget {
  static String routeName = "/productOverview";
  @override
  _ProductOverviewState createState() => _ProductOverviewState();
}

enum FilterOption {
  ShowAll,
  Favourit,
}

class _ProductOverviewState extends State<ProductOverview> {
  bool showOnlyFav = false;
  bool isInit = true;
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError(
        (e) => showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Something went wrong"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: Text("ok"))
            ],
          ),
        ),
      );
    }
    isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My shop"),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badge(
                child: ch,
                value: cart.getCartLength.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            onSelected: (value) {
              setState(() {
                if (value == FilterOption.ShowAll) {
                  showOnlyFav = false;
                } else {
                  showOnlyFav = true;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterOption.ShowAll,
              ),
              PopupMenuItem(
                child: Text("Show Favourit"),
                value: FilterOption.Favourit,
              )
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showOnlyFav),
    );
  }
}
