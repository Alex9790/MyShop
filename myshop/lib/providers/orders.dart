import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
//libreria que provee herramientas para convertir data / permite usar json.encode()
import 'dart:convert';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  //Total costo del pedido
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

//Clase para gestionar las ordenes
class Orders with ChangeNotifier {
  //lista de pedidos ya realizados
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    //URL base de firebase mas la collection donde se almacenan los productos
    const url = "https://flutter-update-d1853.firebaseio.com/Orders.json";
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "amount": total,
        //uniform string representation of dates, facilita convertir de vuelta a Datetime cuando recibes el dato
        "dateTime": timestamp.toIso8601String(),
        //para poder guardar en Firebase se debe convertir la lista de CartItem en una lista de Maps
        "products": cartProducts.map((cartProduct) => {
          "id": cartProduct.id,
          "title": cartProduct.title,
          "quantity": cartProduct.quantity,
          "price": cartProduct.price
        }).toList(),
      }),
    );

    //metodo de agregar elemento en la posicion(index) definido y los demas elementos se corren una posicion
    //en este caso todos los nuevos pedidos se insertan al principio de la lista
    _orders.insert(
        0,
        OrderItem(
          //para obtener el id generado en firebase
          id: json.decode(response.body)["name"], 
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ));
    notifyListeners();
  }
}
