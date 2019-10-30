import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_overview_screen.dart';
import 'package:provider/provider.dart';

import './screens/edit_product_screen.dart';
import './screens/UserProductScreen.dart';
import './screens/splash_screen.dart';
import './screens/OrdersScreen.dart';
import './screens/CartScreen.dart';
import './providers/auth.dart';
import './providers/Cart.dart';
import './screens/auth-screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/Orders.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          builder: (ctx, auth, previousProducts) => Products(
            auth.token,
            auth.userUId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          builder: (ctx, auth, previousOrders) => Orders(
            auth.token,
            auth.userUId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      /* returns a new instance of the Provider class*/
      child: Consumer<Auth>(
        // used a consumer, ie, listening to the providers, here so we don't rebuild the upper part
        // of this widget where the ChangeNotifierProviders are
        builder: (ctx, auth, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.red,
            // main font of the application
            fontFamily: 'Lato',
          ),
          // home: ProductsOverviewScreen(),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) =>
                      authResultSnapshot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
