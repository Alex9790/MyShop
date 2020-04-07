import 'package:flutter/material.dart';
//import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
//import '../providers/products.dart';

//Forma de asignar Labels a Integers
enum FilterOptions {
  Favorites,
  All,
}

//pantalla principal donde se mostraran todos los productos en un Grid
class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;

  @override
  Widget build(BuildContext context) {
    //final productsContainer = Provider.of<Products>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("My Shop"),
        //botones para el AppBar
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {              
              setState(() {
                if(selectedValue == FilterOptions.Favorites){
                //productsContainer.showFavoritesOnly();
                _showOnlyFavorites = true;
              }else{
                //productsContainer.showAll();
                _showOnlyFavorites = false;
              }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            //Items del menu, retorna lista de Widgets
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Solo favoritos"),
                //identificador del item del menu
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Todos"),
                //identificador del item del menu
                value: FilterOptions.All,
              ),
            ],
          ),
        ],
      ),
      //se utiliza el metodo builder() que funciona igual a las ListView() donde no sabes cuantos elementos seran, y se mostraran solo los que quepan en pantalla
      body: ProductsGrid(_showOnlyFavorites),
    );
  }
}
