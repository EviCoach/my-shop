import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/AppDrawer.dart';
import '../providers/Orders.dart' show Orders;
import '../widgets/OrderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/ordera';

  @override
  Widget build(BuildContext context) {
    print('build runs once');
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchAndSet(),
          builder: (
            ctx,
            snapshot,
            /** snapshot - data currently returned by the future */
          ) {
            // multiline function body
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.error != null) {
                // handle error here
                return Center(child: Text('An error occurred!'));
              } else {
                return Consumer<Orders>(
                  // used a consumer here to avoid rebuilding the whole screen and thereby
                  // running futureBuilder again, resulting in an infinit loop
                  builder: (ctx, orderData, child) => ListView.builder(
                    itemBuilder: (ctx, index) {
                      // use OrderItem to display each list
                      return OrderItem(orderData.orders[index]);
                    },
                    itemCount: orderData.orders.length,
                  ),
                );
              }
            }
          },
        ));
  }
}
