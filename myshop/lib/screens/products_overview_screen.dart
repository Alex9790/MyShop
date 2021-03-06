import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../providers/products.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';

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
  //para cargar los productos cuando se caraga por primera vez la pantalla
  var _isInit = true;
  //para mostrar pantalla de carga
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    //esto no funciona porque context aun no esta definido en initState
    //Provider.of<Products>(context).fetchAndSetProducts();
    //Solucion 1
    //Future.delayed(Duration.zero).then((_){
    //	Provider.of<Products>(context).fetchAndSetProducts();
    //});
  }

  //Solucion dos para obtener productos desde Backend
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

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
                if (selectedValue == FilterOptions.Favorites) {
                  //productsContainer.showFavoritesOnly();
                  _showOnlyFavorites = true;
                } else {
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
          //Icono para ir al Carrito, se usa el Widget Badge() que provee el curso
          //Se usa Consumer para solo rebuild los widgets contenidos en el argumento "builder"
          Consumer<Cart>(
            builder: (context, cart, child1) {
              return Badge(
                child: child1,
                //esto es lo unico que nos interesa actualizar
                value: cart.itemCount.toString(),
              );
            },
            //se usa este argumento para que Consumer no lo rebuild, y obtenerlo como parametro en el builder "child1"
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {
                //ir a la pantalla del carrito
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      //Para incluir en esta pantalla el Drawer definido
      drawer: AppDrawer(),
      //se utiliza el metodo builder() que funciona igual a las ListView() donde no sabes cuantos elementos seran, y se mostraran solo los que quepan en pantalla
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
