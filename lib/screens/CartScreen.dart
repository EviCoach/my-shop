import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart' show Cart;
import '../widgets/CartItem.dart';
import '../providers/Orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            elevation: 2,
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Consumer<Orders>(
                    builder: (ctx, orders, child) {
                      return FlatButton(
                        // color: Theme.of(context).primaryColor,
                        child: Text(
                          'Order Now',
                          // style: TextStyle(
                          //     color:
                          //         Theme.of(context).primaryTextTheme.title.color),
                        ),
                        onPressed: () {
                          orders.addOrder(
                              cart.items.values.toList(), cart.totalAmount);
                          cart.clear();
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, index) => CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[
                      index], // the product id that was used as the key
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                  cart.items.values.toList()[index].title),
              itemCount: cart.itemNum,
            ),
          )
        ],
      ),
    );
  }
}
