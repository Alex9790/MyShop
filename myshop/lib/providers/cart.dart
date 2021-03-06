import 'package:flutter/foundation.dart';

class CartItem {
  //este id es diferente al producto que se gestiona
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  //Map donde la key es el id del producto
  Map<String, CartItem> _items = {};

  //Metodo get para obtener todos los productos del carrito
  Map<String, CartItem> get items {
    return {..._items};
  }

  //retorna la cantidad de productos contenidos en el Map
  int get itemCount {
    return _items.length;
  }

  //Monto total del pedido
  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  //metodo para agregar productos al carrito, se asume cantidad 1, se agregan productos uno por uno
  void addItem(String productId, double price, String title) {
    //se revisa si ya se encuentra el producto
    if (_items.containsKey(productId)) {
      //si ya esta, solo se suma cantidad
      _items.update(
        productId,
        (existingItem) => new CartItem(
          id: existingItem.id,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        ),
      );
    } else {
      //si no esta se agrega todo el producto, putIfAbsent(id, Function que retorna el Value)
      _items.putIfAbsent(
        productId,
        () => new CartItem(
          id: DateTime.now().toString(),
          title: title,
          quantity: 1,
          price: price,
        ),
      );
    }
    //recordar siempre
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      //en caso de que el carrito no tenga este producto
      return;
    }
    //actualizar la cantidad de productos
    if (_items[productId].quantity > 1) {
      //si tiene mas de un mismo producto, se reduce la cantidad en 1      
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          quantity: existingCartItem.quantity - 1,
          price: existingCartItem.price,
        ),
      );
    }else{
      //si tiene un solo produto, se elimina
      _items.remove(productId);
    }

    notifyListeners();
  }

  //metodo para eliminar elementos del Map _items
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //metodo para limpiar todo el carrito
  void clear() {
    _items = {};
    notifyListeners();
  }
}
