import 'package:flutter/material.dart';

import '../models/product.dart';
import '../widgets/product_item.dart';

//pantalla principal donde se mostraran todos los productos en un Grid
class ProductsOverviewScreen extends StatelessWidget {
  final List<Product> loadedProducts = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
      ),
      //se utiliza el metodo builder() que funciona igual a las ListView() donde no sabes cuantos elementos seran, y se mostraran solo los que quepan en pantalla
      body: GridView.builder(
        //define como el Grid sera estructurado
        //con esa clase define cuantos elementos debe acomodar en pantalla
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //cantidad de columnas que se quieren tener
          crossAxisCount: 2,
          //los elementos seran un poco mas anchos que altos
          childAspectRatio: 3 / 2,
          //espacio entre columnas
          crossAxisSpacing: 10,
          //espacio entre filas
          mainAxisSpacing: 10,
        ),
        //gestionara los Widgets que se muestren dentro del Grid
        itemBuilder: (context, index) => ProductItem(
          loadedProducts[index].id,
          loadedProducts[index].title,
          loadedProducts[index].imageUrl,
        ),
        //se usa const para evitar q e vuelva a renderizar cuando se actualice el estado de la App
        padding: const EdgeInsets.all(10.0),
        //cuantos elementos contendra el Gird
        itemCount: loadedProducts.length,
      ),
    );
  }
}
