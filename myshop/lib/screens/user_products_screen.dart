import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        //se usa const para que no sean reconstruidos al actualizar la lista de productos
        title: const Text("Gestion de Productos"),
        //opciones del appbar
        actions: <Widget>[
          //opcion para agregar productos
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //navegar a la funcion para agregar productos
            },
          ),
        ],
      ),
      //Para incluir en esta pantalla el Drawer definido
      drawer: AppDrawer(),
      //se debe mostrar la lista de todos los productos
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
          //cantidad de productos
          itemCount: productsData.items.length,
          itemBuilder: (context, index) => Column(
            children: <Widget>[
              UserProductItem(
                productsData.items[index].title,
                productsData.items[index].imageUrl,
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
