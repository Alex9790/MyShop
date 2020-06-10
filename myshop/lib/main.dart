import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/auth.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        /*ChangeNotifierProvider.value(
          //se debe agregar una instancia de la clase provider a utilizar, antes el argumento era "builder"
          //create: (ctx) => Products(),
          value: Products(),
        ),*/
        //Este metodo depende de Auth, por lo tanto Auth debe ser declarado arriba de este
        ChangeNotifierProxyProvider<Auth, Products>(
          //creas el provider con data inicial
          create: (context) => Products("", "", []),
          //cada actualizacion que ocurra en Auth, es notifica a Products y por lo tanto se actualiza
          update: (context, auth, previousProducts) => Products(
            auth.token,
            auth.userId,
            previousProducts == null ? [] : previousProducts.items,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        /*ChangeNotifierProvider.value(
          value: Orders(),
        ),*/
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders("", "", []),
          update: (context, auth, previousOrders) => Orders(
            auth.token,
            auth.userId,
            previousOrders == null ? [] : previousOrders.orders,
          ),
        ),
      ],
      //la idea es revisar si el usuario se encuentra autenticado o no, con la intencion de decidir si mostrar la pantalla de autenticacion o la lista de productos
      child: Consumer<Auth>(
        builder: (context, auth, child) => MaterialApp(
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: "Lato",
          ),
          //si el token es valido va directo a la pantalla principal, lista de productos
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrdersScreen.routeName: (context) => OrdersScreen(),
            UserProductsScreen.routeName: (context) => UserProductsScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
            AuthScreen.routeName: (context) => AuthScreen(),
          },
        ),
      ),
    );
  }
}
