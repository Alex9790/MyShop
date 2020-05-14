import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";

  //se recibe el context asi por parametro poque este no es un Staful Widget
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProducts();
  }

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
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      //Para incluir en esta pantalla el Drawer definido
      drawer: AppDrawer(),
      //se debe mostrar la lista de todos los productos
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            //cantidad de productos
            itemCount: productsData.items.length,
            itemBuilder: (context, index) => Column(
              children: <Widget>[
                UserProductItem(
                  productsData.items[index].id,
                  productsData.items[index].title,
                  productsData.items[index].imageUrl,
                ),
                Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
