import 'package:flutter/material.dart';
import 'package:my_shop/screens/product_overview_screen.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'MyShop',
        theme: ThemeData(
          primarySwatch: Colors.green,
          accentColor: Colors.red,
        ),
        home: ProductsOverviewScreen());
  }
}