import 'package:flutter/foundation.dart';

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

  void addOrder (List<CartItem> cartProducts, double total){
    //metodo de agregar elemento en la posicion(index) definido y los demas elementos se corren una posicion
    //en este caso todos los nuevos pedidos se insertan al principio de la lista
    _orders.insert(0, OrderItem(id: DateTime.now().toString(), amount: total, products: cartProducts, dateTime: DateTime.now()));
    notifyListeners();
  }
}
