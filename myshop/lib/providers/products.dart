import 'package:flutter/material.dart';

import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
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

  void addProduct(Product product) {
    final newProduct = Product(
        id: DateTime.now().toString(),
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
  }

  void updateProduct(String id, Product newProduct){
    //para obtener el indice del product que se va a actualizar
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if(prodIndex > 0){
      //se actualiza con los nuevos datos
      _items[prodIndex] = newProduct;
      notifyListeners();
    }else{
      print("No se encontro el indice.");
    }
    
  }

  void deleteProduct (String id){
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
