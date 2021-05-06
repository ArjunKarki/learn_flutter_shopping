import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/cart.dart' show Cart;
import 'package:shopping_app/providers/orders.dart';
import 'package:shopping_app/widgets/cartItem.dart';

class CartScreen extends StatelessWidget {
  static final String routeName = "/cart";
  @override
  Widget build(BuildContext context) {
    Cart cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Cart",
        ),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.getTotalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 8),
              itemCount: cart.getCart.length,
              itemBuilder: (context, i) => Card(
                child: CartItem(
                  title: cart.getCart.values.toList()[i].title,
                  id: cart.getCart.values.toList()[i].id,
                  productId: cart.getCart.keys.toList()[i],
                  price: cart.getCart.values.toList()[i].price,
                  quantity: cart.getCart.values.toList()[i].quantity,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.getCart.length == 0 || isLoading == true)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.getTotalAmount,
                widget.cart.getCart.values.toList(),
              );
              setState(() {
                isLoading = false;
              });
              widget.cart.clearCart();
            },
      child: isLoading
          ? CircularProgressIndicator()
          : Text(
              "ORDER NOW",
              style: TextStyle(
                color: Theme.of(context).primaryColor,
                letterSpacing: 1,
              ),
            ),
    );
  }
}
