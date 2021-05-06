import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/orders.dart';

class OrderItem extends StatefulWidget {
  final OrderItems order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.order.amount.toStringAsFixed(2)),
            subtitle:
                Text(DateFormat("dd/MM/yyyy  hh:mm").format(widget.order.time)),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ),
          if (_isExpanded)
            Column(
              children: [
                Container(
                  height: 0.5,
                  width: double.infinity,
                  color: Colors.black38,
                ),
                Container(
                  color: Colors.black.withOpacity(0.1),
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: min(widget.order.products.length * 20.0 + 20, 180),
                  child: ListView(
                    children: widget.order.products
                        .map(
                          (product) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(product.title),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                    '${product.price} x ${product.quantity}'),
                              )
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
