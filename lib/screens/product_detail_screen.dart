import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static final routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    String id =
        ModalRoute.of(context).settings.arguments as String; // as the id
    // here... get all the product data for that
    // find the product with the given id in the provider
    final loadedProduct = Provider.of<Products>(context).findById(id);
    // .items
    // .firstWhere((prod) => prod.id == id);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
