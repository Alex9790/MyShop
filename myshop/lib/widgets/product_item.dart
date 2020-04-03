import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/product_detail_screen.dart';
import '../providers/product.dart';

//este Widget sera el item dentro del Grid que contendra la informacion de cada producto
class ProductItem extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  //ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //Recibe ahora los datos del Product a traves de un State Provider
    final producto = Provider.of<Product>(context);
    //Clip Rounded Rectangle, forza los elementos hijos a adaptarse a una forma definida
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      //parecido al ListTile de ListViews
      child: GridTile(
        //Widget para implementar un listener, debido a que Image() no tiene esa opcion
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              //se envia solo el id para q a partir de el acceder al arreglo con todos los demas datos
              arguments: producto.id,
            );
          },
          child: Image.network(
            producto.imageUrl,
            //para que use todo el espacio que pueda obtener
            fit: BoxFit.cover,
          ),
        ),
        //configura una barra ubicada en el footer de GridTile
        footer: GridTileBar(
          //background negro con opacidad 54 / permitiendo ese efecto de transparencia
          backgroundColor: Colors.black87,
          //define Widget al inicio de la barra
          leading: IconButton(
            //cambia el icono dependiendo de si es favorito o no
            icon: Icon(producto.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: () {
              //asigna o desasigna un producto como favorito
              producto.toggleFavoriteStatus();
            },
            color: Theme.of(context).accentColor,
          ),
          //define contenido en el centro de la Barra
          title: Text(
            producto.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
