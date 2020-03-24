import 'package:flutter/material.dart';

//este Widget sera el item dentro del Grid que contendra la informacion de cada producto
class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  ProductItem(this.id, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    //parecido al ListTile de ListViews
    return GridTile(
      child: Image.network(
        imageUrl,
        //para que use todo el espacio que pueda obtener
        fit: BoxFit.cover,
      ),
      //configura una barra ubicada en el footer de GridTile
      footer: GridTileBar(
        backgroundColor: Colors.black54,
        //define Widget al inicio de la barra
        leading: IconButton(
          icon: Icon(Icons.favorite),
          onPressed: () {},
        ),
        //define contenido en el centro de la Barra
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {},
        ),
      ),
    );
  }
}
