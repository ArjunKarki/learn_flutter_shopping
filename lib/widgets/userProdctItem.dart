import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/products.dart';
import 'package:shopping_app/screens/productEditScreen.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String id;
  final String imgUrl;

  const UserProductItem({this.id, this.title, this.imgUrl});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imgUrl),
        ),
        title: Text(title),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).primaryColor,
                ),
                onPressed: () {
                  Navigator.of(context)
                      .pushNamed(ProdctEditScreen.routeName, arguments: id);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Delet Prodct"),
                      content: Text("Are you sure to delete product?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Provider.of<Products>(context, listen: false)
                                .deletProduct(id);
                            Navigator.of(context).pop();
                          },
                          child: Text("Ok"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancle"),
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
