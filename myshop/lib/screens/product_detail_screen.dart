import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  //final String title;
  //ProductDetailScreen(this.title);

  static final routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    //se obtiene el id
    final productId = ModalRoute.of(context).settings.arguments as String;
    //se implementa la funcionalidad de busqueda del producto en el State Provider
    final loadedProduct = Provider.of<Products>(
      context,
      //con este parametro, cuando se llame al metodo "notifyListeners();" este widget no sera actualizado
      //util para cuando se quiere obtener data solo una vez y no quieres actualizaciones. Ej. data global que no se modifique
      listen: false,
    ).findById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: Center(
        child: Text(loadedProduct.description),
      ),
    );
  }
}
