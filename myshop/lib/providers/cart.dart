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
  Map<String, CartItem> _items;

  //Metodo get para obtener todos los productos del carrito
  Map<String, CartItem> get items {
    return {..._items};
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
  }
}
