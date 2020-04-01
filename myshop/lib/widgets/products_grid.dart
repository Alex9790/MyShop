import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {

    //Configuracion del Listener para escuchar los cambios realizados en el State Provider "Products"
    //le decimos al Package Provider que queremos comunicacion directa con la instancia proveida de la clase Products
    //de esta forma Provider rastrea toda la ascendencia de est Widget hasta encontrar al Proveedor que provee una instancia de tipo Products
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
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
        products[index].id,
        products[index].title,
        products[index].imageUrl,
      ),
      //se usa const para evitar q e vuelva a renderizar cuando se actualice el estado de la App
      padding: const EdgeInsets.all(10.0),
      //cuantos elementos contendra el Gird
      itemCount: products.length,
    );
  }
}
