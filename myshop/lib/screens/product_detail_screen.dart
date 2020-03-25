import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  //final String title;
  //ProductDetailScreen(this.title);

  static final routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    //se obtiene el id
    final productId = ModalRoute.of(context).settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text("title"),
      ),
      body: Center(
        child: Text("Detalles de Producto"),
      ),
    );
  }
}
