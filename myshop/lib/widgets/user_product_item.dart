import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //se crea esta variable para poder ser usada en el catch de eliminar producto
    //debido a que como la funcion es async, por lo tanto es Future, dart no puede estar seguro de context asi que genera un error
    final scaffold = Scaffold.of(context);

    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      //para incluir opciones con la que interactuar, se usa Container para evitar conflictos de espacio entre trailing y Row()
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                //navegacion para ir a la pantalla de edicion de productos, se manda como parametro el id del producto para buscarlo en la pantalla
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  //para eliminar un producto de la lista, se agrega async y await para poder gestionar el posible error, de lo contrario dart no espera por el Future
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  //se muestra ScnakBar del error
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Error al eliminar producto", textAlign: TextAlign.center,),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
