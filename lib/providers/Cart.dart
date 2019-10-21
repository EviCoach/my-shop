import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.title,
    @required this.id,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items;

  Map<String, CartItem> get items {
    return {..._items};
  }

  void addItem(
    String productId,
    double price,
    String title,
  ) {
    if (_items.containsKey(productId)) {
      // change quantity...ie, update
      _items.update(
        productId,
        (existingCartitem) => CartItem(
          id: existingCartitem.id,
          title: existingCartitem.title,
          price: existingCartitem.price,
          quantity: existingCartitem.quantity + 1,
        ),
      );
    } else {
      // we are adding it for the first time
      _items.putIfAbsent(
        productId,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            price: price,
            quantity: 1),
      );
    }
  }
}
