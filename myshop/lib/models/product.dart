import 'package:flutter/foundation.dart'; //para poder agregar @required

//clase que servira de modelo para todos los productos
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite; //notar que no es final porque puede cambiar

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});  //valor por defecto
}
