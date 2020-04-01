import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

//pantalla principal donde se mostraran todos los productos en un Grid
class ProductsOverviewScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      //se utiliza el metodo builder() que funciona igual a las ListView() donde no sabes cuantos elementos seran, y se mostraran solo los que quepan en pantalla
      body: ProductsGrid(),
    );
  }
}