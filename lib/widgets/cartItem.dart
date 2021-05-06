import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final double price;
  final String title;
  final int quantity;
  final String productId;
  final String id;

  CartItem({this.price, this.title, this.quantity, this.productId, this.id});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteCart(productId);
      },
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Sure To Delete"),
            content: Text("This is content"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text("Ok"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text("Cancle"),
              )
            ],
          ),
        );
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 10),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      key: ValueKey(id),
      child: ListTile(
        leading: CircleAvatar(
          child: FittedBox(
            child: Text(
              '\$$price',
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text("Total: ${quantity * price}"),
        trailing: Text('$quantity x'),
      ),
    );
  }
}
