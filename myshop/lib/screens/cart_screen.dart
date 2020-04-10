import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

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
                      "\$${cart.totalAmount}",
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                      onPressed: () {},
                      child: Text(
                        "Order Now!",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
