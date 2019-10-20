import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static final routeName = '/product-detail-screen';

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments as String; // as the id
    // here... get all the product data for that id
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
