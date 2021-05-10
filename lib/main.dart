import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/providers/cart.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/authScreen.dart';
import 'package:shopping_app/screens/cartScreen.dart';
import 'package:shopping_app/screens/orderScreen.dart';
import 'package:shopping_app/screens/productDetailScreen.dart';
import 'package:shopping_app/screens/productEditScreen.dart';
import 'package:shopping_app/screens/productOverviewScreen.dart';
import 'package:shopping_app/screens/splashScreen.dart';
import 'package:shopping_app/screens/userProductScreen.dart';

void main() {
  runApp(MyApp());
  Provider.debugCheckInvalidValueType = null;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ProxyProvider<Auth, Products>(
          update: (context, auth, previous) =>
              Products(auth.userId, auth.token),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ProxyProvider<Auth, Orders>(
          update: (context, auth, previous) => Orders(auth.userId, auth.token),
        ),
        // ChangeNotifierProvider(create: (context) => Orders())
      ],
      child: Consumer<Auth>(
        builder: (_, auth, __) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
              fontFamily: "Lato",
            ),
            routes: {
              ProductOverview.routeName: (context) => ProductOverview(),
              AuthScreen.routeName: (context) => AuthScreen(),
              ProductDetail.routeName: (context) => ProductDetail(),
              CartScreen.routeName: (context) => CartScreen(),
              OrderScreen.routeName: (context) => OrderScreen(),
              UserProductScreen.routeName: (context) => UserProductScreen(),
              ProdctEditScreen.routeName: (context) => ProdctEditScreen()
            },
            home: auth.isAuth
                ? ProductOverview()
                : FutureBuilder(
                    future: auth.autoLogin(),
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
          );
        },
      ),
    );
  }
}
