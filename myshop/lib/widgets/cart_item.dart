import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;

  CartItem(this.id, this.productId, this.price, this.quantity, this.title);

  @override
  Widget build(BuildContext context) {
    //Crea la animacion y el efecto de eliminar elementos de una lista al arrastrar a un lado
    return Dismissible(
      key: ValueKey(id),
      //color de fondo que muestra al arrastrar un item de la lista
      background: Container(
        color: Theme.of(context).errorColor,
        //para mostrar icono de papelera al eliminar elemento
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        //colocar icono a la derecha y en el centro
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      //argumento para restringir la animacion, en este caso sera para eliminar solo de derecha a izquierda
      direction: DismissDirection.endToStart,
      //Event Listener, funcion que se ejecuta cuando se elimina un elemento de la vista
      //direction: en caso de querer hacer algo diferente dependiendo de la direccion
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              //como es una solo palabra lo {} no son necesarios
              child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(child: Text("\$$price"))),
            ),
            title: Text(title),
            subtitle: Text("Total \$${(price * quantity)}"),
            trailing: Text("$quantity X"),
          ),
        ),
      ),
    );
  }
}
