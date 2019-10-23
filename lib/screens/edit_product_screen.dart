import 'package:flutter/material.dart';

import '../providers/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  /// the globalkey will allow us to interract with the state behind
  /// the form widget
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm() {
    final isValid = _form.currentState.validate();
    // submit the form with the help of the form widget
    // global keys are needed when you need to to
    // interact with a widget from inside your code ie methods
    if (!isValid) {
      return;
    }
    if (isValid) {
      _form.currentState
          .save(); // this will trigger a method on every textFormField
    }

    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.imageUrl);
    print(_editedProduct.price);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,

          /// establish a connection to the form
          child: ListView(
            children: <Widget>[
              Card(
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      errorStyle:
                          TextStyle(color: Theme.of(context).errorColor),
                      labelText: 'Title',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10)),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted:
                      (value /*value that was entered in the field*/) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: value,
                      price: _editedProduct.price,
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
              ),
              Card(
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    if (double.parse(value) <= 0) {
                      return 'Please enter a number greater than zero.';
                    }
                    return null; // 'cos now we have a valid number
                  },
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: double.parse(value),
                      description: _editedProduct.description,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
              ),
              Card(
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Desicription',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                  focusNode: _descriptionFocusNode,
                  maxLines: 4,
                  keyboardType: TextInputType.multiline,
                  onSaved: (value) {
                    _editedProduct = Product(
                      title: _editedProduct.title,
                      price: _editedProduct.price,
                      description: value,
                      imageUrl: _editedProduct.imageUrl,
                      id: null,
                    );
                  },
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      child: Center(
                        child: _imageUrlController.text.isEmpty
                            ? Text('Enter a URL')
                            : FittedBox(
                                child: Image.network(
                                  /** Use text controller to get the value of the text field
                                   * if you want to use the value before the form is submitted
                                   */
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter an image URL.';
                        }
                        if (!value.startsWith('http') ||
                            !value.startsWith('https')) {
                          return 'Please enter a valid url';
                        }
                        if (!value.endsWith('.png') ||
                            !value.endsWith('.jpg') ||
                            !value.endsWith('.jpeg')) {
                          return 'Please enter a valid image URL';
                        }
                        return null;
                      },
                      // takes as much width as it can get
                      decoration: InputDecoration(labelText: 'Image URL'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      /* the _imageUrlController is updated when we type into the TextFormField */
                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: null,
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
