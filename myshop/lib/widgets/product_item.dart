import 'package:flutter/material.dart';

//este Widget sera el item dentro del Grid que contendra la informacion de cada producto
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //Clip Rounded Rectangle, forza los elementos hijos a adaptarse a una forma definida
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      //parecido al ListTile de ListViews
      child: GridTile(
        child: Image.network(
          imageUrl,
          //para que use todo el espacio que pueda obtener
          fit: BoxFit.cover,
        ),
        //configura una barra ubicada en el footer de GridTile
        footer: GridTileBar(
          //background negro con opacidad 54 / permitiendo ese efecto de transparencia
          backgroundColor: Colors.black87,
          //define Widget al inicio de la barra
          leading: IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {},
            color: Theme.of(context).accentColor,
          ),
          //define contenido en el centro de la Barra
          title: Text(
            title,
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
