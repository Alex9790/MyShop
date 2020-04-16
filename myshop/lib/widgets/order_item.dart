import 'package:flutter/material.dart';
//para utilizar DateFormat
import 'package:intl/intl.dart';

//se utiliza "as ord" porque orders.dart tambien tiene definida una clase "OrderItem"
import '../providers/orders.dart' as ord;

class OrderItem extends StatelessWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("\$${order.amount}"),
            subtitle: Text(
              DateFormat("dd MM yyyy hh:mm").format(order.dateTime),
            ),
            trailing: IconButton(icon: Icon(Icons.expand_more), onPressed: null),
          ),
        ],
      ),
    );
  }
}
