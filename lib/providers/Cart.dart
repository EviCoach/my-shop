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
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    int quantity = 0;
    _items.forEach((key, value) {
      quantity += value.quantity;
    });
    return quantity;
  }

  int get itemNum {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
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
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId].quantity > 1) {
      _items.update(
        productId,
        (existingCartItem) => CartItem(
            id: existingCartItem.id,
            price: existingCartItem.price,
            title: existingCartItem.title,
            quantity: existingCartItem.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  // clear the cart when you make an order
  void clear() {
    _items = {};
    notifyListeners();
  }
}
