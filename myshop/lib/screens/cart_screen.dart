import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';
import '../providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                //separa lo mas posible los elementos contenidos
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  //Widget que toma todo el espacio disponible para el, lo que ocurre aqui es dejar el label total en extremo izquierdo
                  //y el total y boton para fnalizar orden en el Extremo derecho
                  Spacer(),
                  //Widget que crea un contenedor ovalado
                  Chip(
                    label: Text(
                      //limitar la cantidad de decimales a 2
                      "\$${cart.totalAmount.toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    onPressed: () {
                      //Se accede a la lista de Pedidos y se le agrega un nuevo pedido
                      //en vez de pasar todo el Map se pasa solo la lista de productos
                      //no quereos escuchar aqui porque solo queremos registrar un pedido
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cart.items.values.toList(),
                        cart.totalAmount,
                      );
                      //se eliminan los items del carrito
                      cart.clear();
                    },
                    child: Text(
                      "Order Now!",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          //Para que tome todo el resto dle espacio disponible en el Column()
          Expanded(
              //ListView para mostrar todos los productos dentro del carrito, como no sabemos cuantos seran se utiliza .builder
              child: ListView.builder(
            //cantidad de items dentro del carrito
            itemCount: cart.items.length,
            itemBuilder: (context, index) => CartItem(
                cart.items.values.toList()[index].id,
                cart.items.keys.toList()[index],
                cart.items.values.toList()[index].price,
                cart.items.values.toList()[index].quantity,
                cart.items.values.toList()[index].title),
          ))
        ],
      ),
    );
  }
}
