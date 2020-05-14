import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//libreria que provee herramientas para convertir data
import 'dart:convert';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
/*    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
*/
  ];
  //para filtrar lista de productos
  /*Esta forma de aplicar filtros afectara todas las pantallas de productos, por lo que no se recomienda
  var _showFavoritesOnly = false;*/

  //para obtener copia de datos _items
  List<Product> get items {
    /*Esta forma de aplicar filtros afectara todas las pantallas de productos, por lo que no se recomienda
    if(_showFavoritesOnly){
      return _items.where((prodItem) => prodItem.isFavorite).toList();
    }*/
    //se retorna una copia de los datos originales, en vez de un apuntado a los mismos (return items;)
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  //se busca el produto con el id recibido por parametro
  Product findById(String id) {
    return _items.firstWhere((producto) => producto.id == id);
  }

  //metodo para obtener los productos de Firebase
  Future<void> fetchAndSetProducts() async {
    const url = "https://flutter-update-d1853.firebaseio.com/Products.json";

    try {
      //peticion GET para obtener los productos
      final response = await http.get(url);
      print(response);
      print(json.decode(response.body));
      //se observa en el print() que se recibe un Map<String, Map>, pero Dart da un error si se coloca Map dentro del Map asi que se coloca dynamic
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((productId, productData) {
        loadedProducts.add(
          Product(
            id: productId,
            title: productData["title"],
            description: productData["dscription"],
            price: productData["price"],
            imageUrl: productData["imageUrl"],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print("Error: " + error);
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    //URL base de firebase mas la collection donde se almacenan los productos
    const url = "https://flutter-update-d1853.firebaseio.com/Products.json";

    try {
      //peticion POST, que se ejecuta de manera asincrona sin detener la ejecucion del resto del metodo
      //con el cambio de void a Future<void> se debe retornar un future, no se puede colocar "return Future.value()" porque se ejecutaria de inmediato (ejecucion asyncrona)
      final response = await http.post(
        url,
        //usando la libreria convert de Dart
        body: json.encode({
          "title": product.title,
          "description": product.description,
          "imageUrl": product.imageUrl,
          "price": product.price,
          "isFavorited": product.isFavorite,
        }),
      );

      //para ver el contenido del response
      print(json.decode(response.body));

      //se ejecuta esta seccion dentro de then() para forzarlo a esperar que se guarde el objeto en firebase y obtener el id generado en el response
      final newProduct = Product(
          //para obtener el id generado por firebase
          id: json.decode(response.body)["name"],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items.add(newProduct);
      //para insertar al inicio de la lista
      //_items.insert(0, newProduct);
      //se utiliza para informar a todos los Widgets que estan conectados a este Provider con Listener
      //que hay informacion nueva disponible
      notifyListeners();
    } catch (error) {
      print("Error: " + error);
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    //para obtener el indice del product que se va a actualizar
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex > 0) {
      //para actualizar productos tambien en Firebase
      //se cambia a final porque id es variable
      final url =
          "https://flutter-update-d1853.firebaseio.com/Products/$id.json";
      await http.patch(
        url,
        body: json.encode({
          "title": newProduct.title,
          "description": newProduct.description,
          "imageUrl": newProduct.imageUrl,
          "price": newProduct.price,
          "isFavorited": newProduct.isFavorite,
        }),
      );
      //se actualiza con los nuevos datos
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("No se encontro el indice.");
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

/*Esta forma de aplicar filtros afectara todas las pantallas de productos, por lo que no se recomienda

  void showFavoritesOnly (){
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void showAll (){
    _showFavoritesOnly = false;
    notifyListeners();
  }
*/
}
