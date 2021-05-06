import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/appDrawer.dart';
import 'package:shopping_app/widgets/orderItems.dart';

class OrderScreen extends StatefulWidget {
  static final routeName = "/orders";

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    isLoading = true;
    Future.delayed(Duration.zero).then((value) {
      Provider.of<Orders>(context, listen: false).fetchOrders();
    }).then((value) {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Orders order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Orders"),
      ),
      drawer: AppDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: order.getOrders.length,
              itemBuilder: (context, i) => OrderItem(order.getOrders[i]),
            ),
    );
  }
}
