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
                  OrderButton(cart: cart),
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      //se desactiva el boton si no hay elementos en el carrito o si esta cargando un pedido
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading) 
      ? null : () async {
        setState(() {
          _isLoading = true;
        });
        //Se accede a la lista de Pedidos y se le agrega un nuevo pedido
        //en vez de pasar todo el Map se pasa solo la lista de productos
        //no queremos escuchar aqui porque solo queremos registrar un pedido
        await Provider.of<Orders>(context, listen: false).addOrder(
          widget.cart.items.values.toList(),
          widget.cart.totalAmount,
        );

        setState(() {
          _isLoading = false;
        });
        
        //se eliminan los items del carrito
        widget.cart.clear();
      },
      //se muestra spinner de loading en vez de texto cuando se estan guardando pedidos
      child: _isLoading ? CircularProgressIndicator() : Text(
        "Order Now!",
        style: TextStyle(
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
