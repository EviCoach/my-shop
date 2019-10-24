import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/AppDrawer.dart';
import '../providers/products.dart';
import '../widgets/UserProductItem.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // ... navigate to the new product screen
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          itemBuilder: (ctx, index) => Column(
            children: <Widget>[
              UserProductItem(
                productData.items[index].id,
                productData.items[index].title,
                productData.items[index].imageUrl,
              ),
              Divider(),
            ],
          ), // the widget for each list of products

          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
