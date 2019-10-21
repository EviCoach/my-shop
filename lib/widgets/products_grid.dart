import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_items.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;
  ProductsGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(
        context); // gives us access to the products object
    final products = showFavs ? productsData.favoriteItem : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(
          10.0), // uses const to prevent rebuild of the padding widgets
      itemCount: products.length,
      // itemBuilder defines how every grid item or cell should be built
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index], // setting each product as a provider
        child: ProductItem(
            // products[index].id,
            // products[index].title,
            // products[index].imageUrl,
            // products[index].price,
            ),
      ),

      // gridDelegate defines how the grid should be structured
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
