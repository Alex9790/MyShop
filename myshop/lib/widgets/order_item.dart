import 'package:flutter/material.dart';
//para utilizar DateFormat
import 'package:intl/intl.dart';
import 'dart:math';

//se utiliza "as ord" porque orders.dart tambien tiene definida una clase "OrderItem"
import '../providers/orders.dart' as ord;

//se define StatefulWidget porque necesitamos que cambie la interfaz cuando se expanden los pedidos
class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  //para saber cuando este pedido ha sido expandido para mostrar detalles
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${widget.order.amount}"),
            subtitle: Text(
              DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime),
            ),
            //Boton para expandir el pedido y ver mas detalles del mismo
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            //si entiendo bien, se ajusta a la cantidad de productos que tiene (si son pocos, e mostraran sin espacio extra vacio) y un maximo de 180
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 180),
              child: ListView(
                //se deben mostrar los datos de cada "CartItem" en un Widget, para ello se usa .map() que optiene cada "CartItem" y retorna Widgets
                children: widget.order.products
                    .map(
                      (producto) => Row(
                        //para incluir espacio entre los Widgets contenidos
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            producto.title,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${producto.quantity}x \$${producto.price}",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
