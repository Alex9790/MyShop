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
  //token de autenticacion
  final String authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    //URL base de firebase mas la collection donde se almacenan las ordenes
    final url = "https://flutter-update-d1853.firebaseio.com/Orders.json?auth=$authToken";
    final response = await http.get(url);
    print(json.decode(response.body));

    //contendra la lista de productos del pedido
    final List<OrderItem> loadedOrders = [];

    //data de pedidos obtenidos de firebase                   id      map
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //proteger el codigo contra null
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          products: (orderData["products"] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"],
                ),
              )
              .toList(),
          //esto sirve porque se almaceno en Firebase con .toIso8601String()
          dateTime: DateTime.parse(orderData["dateTime"]),
        ),
      );
    });

    //se setea la lista global, se reversa para ordenar con el pedido mas reciente primero
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    //URL base de firebase mas la collection donde se almacenan las ordenes
    final url = "https://flutter-update-d1853.firebaseio.com/Orders.json?auth=$authToken";
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        "amount": total,
        //uniform string representation of dates, facilita convertir de vuelta a Datetime cuando recibes el dato
        "dateTime": timestamp.toIso8601String(),
        //para poder guardar en Firebase se debe convertir la lista de CartItem en una lista de Maps
        "products": cartProducts
            .map((cartProduct) => {
                  "id": cartProduct.id,
                  "title": cartProduct.title,
                  "quantity": cartProduct.quantity,
                  "price": cartProduct.price
                })
            .toList(),
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
