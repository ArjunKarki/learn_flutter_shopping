import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/providers/product.dart';
import 'package:shopping_app/providers/products.dart';

class ProdctEditScreen extends StatefulWidget {
  static String routeName = "/productEdit";
  @override
  _ProdctEditScreenState createState() => _ProdctEditScreenState();
}

class _ProdctEditScreenState extends State<ProdctEditScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  bool isLoading = false;

  var initValues = {
    "title": "",
    "price": "",
    "description": "",
    "imgUrl": "",
  };

  Product _editedProduct = Product(
    id: null,
    title: "",
    price: 0.0,
    description: "",
    imageUrl: "",
  );

  var firstLoad = true;

  @override
  void didChangeDependencies() {
    String productId = ModalRoute.of(context).settings.arguments as String;

    if (firstLoad) {
      if (productId != null) {
        _editedProduct = Provider.of<Products>(context).getById(productId);
        print(_editedProduct.price.toString());
        initValues = {
          "title": _editedProduct.title,
          "price": _editedProduct.price.toString(),
          "description": _editedProduct.description,
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    firstLoad = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(updateImageUrl);
  }

  void updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void saveForm() async {
    bool isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    if (_editedProduct.id != null) {
      Provider.of<Products>(context, listen: false)
          .updteProduct(_editedProduct.id, _editedProduct);
      Navigator.of(context).pop();
    } else {
      setState(() {
        isLoading = true;
      });

      try {
        await Provider.of<Products>(context, listen: false)
            .addProdct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text("Something went wrong"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("ok"),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  String validator(value) {
    if (value.isEmpty) {
      return "Please fill all the form";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Edit"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              saveForm();
            },
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues["title"],
                      decoration: InputDecoration(labelText: "Title"),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) => validator(value),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: value,
                          price: 0.0,
                          description: '',
                          imageUrl: "",
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues["price"].toString(),
                      decoration: InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill all the form";
                        }

                        if (double.tryParse(value) == null) {
                          return "please return valid number";
                        }

                        if (double.parse(value) <= 0) {
                          return "please enter number greater than 0";
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: '',
                          imageUrl: "",
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: initValues["description"],
                      decoration: InputDecoration(labelText: "Description"),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      validator: (value) => validator(value),
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          isFav: _editedProduct.isFav,
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: "",
                        );
                      },
                    ),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          child: Container(
                            child: _imageUrlController.text.isEmpty
                                ? Text("Enter url....")
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: "Enter image url"),
                            keyboardType: TextInputType.url,
                            controller: _imageUrlController,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (value) {
                              saveForm();
                            },
                            validator: (value) => validator(value),
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                isFav: _editedProduct.isFav,
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
