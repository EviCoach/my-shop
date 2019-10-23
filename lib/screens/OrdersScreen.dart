import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/AppDrawer.dart';
import '../providers/Orders.dart' show Orders;
import '../widgets/OrderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/ordera';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemBuilder: (ctx, index) {
          // use OrderItem to display each list
          return OrderItem(orderData.orders[index]);
        },
        itemCount: orderData.orders.length,
      ),
    );
  }
}
