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
      //appBar: AppBar(
      //  title: Text(loadedProduct.title),
      //),
      //contenido del detalle del producto
      body: CustomScrollView(
        //Scrollable areas on the screen
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            //Appbar siempre sera visible
            pinned: true,
            //que deberia estar dentro del AppBar
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
            ),
          ),
          SliverList(
            //como renderizar el contenido de la lista y como debe cambiar
            delegate: SliverChildListDelegate([              
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Text(
                  "\$${loadedProduct.price}",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10),
              Text(
                //loadedProduct.description,
                loadedProduct.description != null
                    ? loadedProduct.description
                    : "Descripción",
                textAlign: TextAlign.center,
                //evita seguir escribiendo como si no hubiera limite de espacio horizontal
                softWrap: true,
              ),
              SizedBox(height: 800),
            ]),
          ),
        ],        
      ),
    );
  }
}
