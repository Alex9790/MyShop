import 'package:flutter/foundation.dart'; //para poder agregar @required
//libreria que provee herramientas para convertir data / permite usar json.encode()
import 'dart:convert';
import 'package:http/http.dart' as http;

//clase que servira de modelo para todos los productos
class Product with ChangeNotifier {
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
      this.isFavorite = false}); //valor por defecto

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    //se guarda el valor actual
    final oldStatus = isFavorite;

    //invierte el valor del boolean que representa si es favorito o no
    isFavorite = !isFavorite;
    //informar a los listener para que actualicen, parece en setState()
    notifyListeners();

    final url = "https://flutter-update-d1853.firebaseio.com/UserFavorites/$userId/$id.json?auth=$token";
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      //error http
      if (response.statusCode >= 400) {
        isFavorite = oldStatus;
        notifyListeners();
      }
    } catch (e) {
      //en caso de error, rollback
      isFavorite = oldStatus;
      notifyListeners();
    }
  }
}
